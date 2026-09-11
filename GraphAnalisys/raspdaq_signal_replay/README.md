# Reprodução de sinais para RaspDAQ / QFIRE HiL

Nó ROS 2 executável diretamente com Python 3, separado do OT1-HiLInfrastructure e da RaspDAQ. Os dois TXT originais estão em `data/`; não há dependência de seus caminhos no computador de desenvolvimento. Requer ROS 2 Humble, `rclpy` e `std_msgs` (já presentes no ambiente ROS da RaspDAQ). Não requer colcon nem pacotes Python adicionais.

O script separa a validação dos dados da execução ROS. Por isso, as importações de `rclpy` e `std_msgs` ficam dentro de `run_ros_replay()`: elas só são carregadas quando o programa realmente publicará mensagens. A opção `--check` consegue validar os TXT sem ROS 2 instalado e informa erros de entrada antes de inicializar o DDS.

## Interface conferida no projeto

Referência: `OT1-HiLInfrastructure/ros2_ws/src/raspdaq_bridge/raspdaq_bridge/raspdaq_node.py`.

| Arquivo | Tópico publicado | Tipo e campo | Variável interna da bridge | Campo USB |
| --- | --- | --- | --- | --- |
| propellerFeedback.txt | `/main_engine_input` | `std_msgs/msg/Float32.data` | `command_main_engine` | `propellerVelocity` |
| rudderFeedback.txt | `/rudder_input` | `std_msgs/msg/Float32.data` | `command_rudder_pump` | `pumpAngularVelocity` |

`command_main_engine` e `command_rudder_pump` não são campos das mensagens ROS. As assinaturas antigas `/ot1/MainEngine` (`propeller_rpm`) e `/ot1/RudderPump` (`rudder_angle_setpoint_rad`) estão comentadas na bridge consultada. O publicador usa QoS reliable, volatile, keep-last depth 1, compatível com as assinaturas ativas reliable/volatile depth 10.

Os valores são enviados diretamente, com a precisão de Float32. Apesar dos nomes históricos do protocolo, o script não transforma ângulo em velocidade nem rad/s em rpm. Os TXT são sinais de feedback utilizados como comandos por solicitação do ensaio; não descrevem unidades em seus cabeçalhos.

## Executar no Raspberry

Copie **toda esta pasta** para o Raspberry (por exemplo, `~/raspdaq_signal_replay`). No terminal do Raspberry:

```bash
source /opt/ros/humble/setup.bash
cd ~/raspdaq_signal_replay
python3 replay_signals.py --check
python3 replay_signals.py
```

Use o mesmo `ROS_DOMAIN_ID` e as mesmas configurações DDS/discovery da bridge. Caso seu ambiente dependa de um overlay ou configuração de shell específica, carregue-os como no terminal usado para a RaspDAQ.

Antes de executar, mantenha a bridge em funcionamento e inicie o streaming USB da QFIRE HiL: `update_daq_to_hil_if_streaming` descarta comandos enquanto o streaming está inativo. A existência de assinantes ROS **não confirma** streaming USB. Desative outros publicadores de comandos nesses dois tópicos (por exemplo, o controlador PX4) durante o ensaio para evitar alternância entre fontes.

O script aguarda até 30 s por pelo menos um assinante em cada tópico, espera mais 3 s e inicia a reprodução. Essa espera não sincroniza o relógio da QFIRE com o instante zero dos arquivos. Para uma preparação mais longa:

```bash
python3 replay_signals.py --start-delay 10 --wait-timeout 60
```

## Amostragem e encerramento

- Cada arquivo tem 16.300 linhas de dados, timestamps irregulares/repetidos e duração de 163,059113 s. Repetições idênticas são removidas; timestamps repetidos com valores distintos são rejeitados.
- Publicação nominal de um par a cada 0,02 s (50 Hz), com primeira amostra em t=0 e interpolação linear. Use `--interpolation hold` para retenção do último valor conhecido.
- O último valor dos arquivos é enviado no próximo instante da grade, t=163,06 s. São 8.154 pares em uma execução sem perdas de prazo.
- Arquivos são carregados antes de iniciar. O relógio é monotônico e independente de `/clock`. Atrasos de um ou mais períodos fazem pular amostras vencidas; não há rajadas para recuperar backlog. O terminal informa pares enviados, instantes pulados e maior atraso observado em relação ao instante selecionado.
- Os dois tópicos são publicados sequencialmente no mesmo callback; não constituem uma transação atômica.
- Ao terminar ou receber Ctrl+C, o nó deixa de publicar; **não envia zero**. A bridge pode conservar o último comando até outro comando ou STOP_STREAM. Encerre o streaming pelo procedimento habitual da QFIRE quando apropriado.
- Python/ROS 2 em Linux comum fornece temporização de melhor esforço, sem garantia de tempo real estrito. Os contadores medem o publicador, não o instante de aplicação pela QFIRE.

Outros arquivos podem ser usados com `--propeller caminho.txt --rudder caminho.txt`; ambos devem iniciar em zero e terminar no mesmo timestamp.

## Verificação local

```bash
python3 replay_signals.py --check
python3 -m unittest -v test_replay.py
```

Para testar o publicador sem a bridge da RaspDAQ, abra dois terminais com o mesmo
ambiente ROS e o mesmo `ROS_DOMAIN_ID`. Inicie primeiro o assinante:

```bash
source /opt/ros/humble/setup.bash
cd ~/raspdaq_signal_replay
python3 subscribe_commands.py
```

Em seguida, inicie o publicador no segundo terminal:

```bash
source /opt/ros/humble/setup.bash
cd ~/raspdaq_signal_replay
python3 replay_signals.py
```

O assinante mostra o tempo local de recepção, número do par e os dois valores.
Use `Ctrl+C` para encerrá-lo e exibir a contagem e a frequência média de cada
tópico. Para reduzir a saída ou encerrar automaticamente:

```bash
python3 subscribe_commands.py --print-every 50 --duration 170
```

Esse assinante satisfaz a descoberta exigida pelo publicador, portanto a bridge
não precisa estar ativa para esse teste. Ele emparelha, para visualização, o valor
novo mais recente de cada tópico; os tópicos continuam sendo mensagens DDS
independentes e não possuem um identificador comum de amostra.

Também é possível observar com as ferramentas de linha de comando do ROS 2:

```bash
ros2 topic hz /main_engine_input
ros2 topic echo /rudder_input
```

Validação realizada no computador de desenvolvimento: 4 testes automatizados passaram; teste ROS 2 com assinantes reais em domínio local separado recebeu os 6 pares esperados de uma tabela sintética de 0,1 s, sem instantes pulados. Esse teste não valida o streaming USB nem a aplicação dos comandos na QFIRE/Raspberry; a integração em hardware permanece a verificar.
