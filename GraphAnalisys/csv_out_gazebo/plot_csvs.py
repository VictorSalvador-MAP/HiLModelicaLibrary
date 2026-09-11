#!/usr/bin/env python3
"""Gráficos interativos por variável numérica; CSVs abertos somente para leitura.

Instalação: python3 -m pip install matplotlib
Uso: python3 plot_csvs.py arquivo1.csv arquivo2.csv
Salvar sem abrir janelas: python3 plot_csvs.py arquivo1.csv arquivo2.csv --salvar graficos --sem-exibir
Timestamp numérico: microssegundos por padrão; ajuste com --unidade-tempo.

No modo padrão, uma página local abre no navegador. Use a roda do mouse para
ampliar, arraste para mover e use "Restaurar zoom" para voltar à visão completa.
"""
import argparse
import csv
import importlib
import json
import math
from pathlib import Path
import re
import sys
import webbrowser


def numero(texto):
    texto = texto.strip()
    # Mantém timestamps inteiros exatos antes de subtrair a origem.
    if re.fullmatch(r'[+-]?\d+', texto):
        return int(texto)
    return float(texto)


def importar_pyplot_interativo():
    """Seleciona uma interface gráfica antes de carregar pyplot.

    Algumas instalações Linux configuram ``Agg`` como padrão, embora tenham
    Tk instalado. Testar o módulo do backend antes evita cair nesse modo que
    gera apenas arquivos de imagem.
    """
    import matplotlib

    candidatos = (
        ('TkAgg', 'matplotlib.backends.backend_tkagg'),
        ('QtAgg', 'matplotlib.backends.backend_qtagg'),
        ('GTK3Agg', 'matplotlib.backends.backend_gtk3agg'),
    )
    erros = []
    for nome, modulo in candidatos:
        try:
            importlib.import_module(modulo)
            matplotlib.use(nome, force=True)
            import matplotlib.pyplot as plt
            return matplotlib, plt
        except (ImportError, RuntimeError) as erro:
            erros.append(f'{nome}: {erro}')

    detalhe = '; '.join(erros)
    raise RuntimeError(
        'Nenhuma interface gráfica do Matplotlib está disponível. '
        'Instale o suporte Tk com "sudo apt install python3-tk" ou execute em uma sessão gráfica. '
        f'Detalhes: {detalhe}'
    )


def carregar(caminho, coluna_tempo):
    with caminho.open('r', encoding='utf-8-sig', newline='') as arquivo:
        amostra = arquivo.read(8192)
        arquivo.seek(0)
        try:
            delimitador = csv.Sniffer().sniff(amostra, delimiters=',;\t|').delimiter
        except csv.Error as exc:
            raise ValueError('Não foi possível identificar o delimitador.') from exc
        leitor = csv.reader(arquivo, delimiter=delimitador)
        cabecalho = [c.strip() for c in next(leitor, [])]
        if not cabecalho or len(set(cabecalho)) != len(cabecalho) or '' in cabecalho:
            raise ValueError('Cabeçalho vazio ou com nomes vazios/duplicados.')
        if coluna_tempo not in cabecalho:
            raise ValueError(f'Coluna de tempo {coluna_tempo!r} ausente: {cabecalho}')
        linhas = []
        for linha in leitor:
            if not linha or all(not v.strip() for v in linha):
                continue
            if len(linha) != len(cabecalho):
                raise ValueError(f'Linha {leitor.line_num}: quantidade de campos incorreta.')
            linhas.append(linha)
    if not linhas:
        raise ValueError('CSV sem registros.')
    indice = cabecalho.index(coluna_tempo)
    tempos, validas = [], []
    for linha in linhas:
        try:
            t = numero(linha[indice])
            if not math.isfinite(t):
                continue
        except ValueError:
            continue
        tempos.append(t)
        validas.append(linha)
    if not tempos:
        raise ValueError('Nenhum timestamp numérico válido.')
    if len(validas) != len(linhas):
        print(f'  Aviso: {len(linhas) - len(validas)} registros sem tempo válido ignorados.')
    ordem = sorted(range(len(tempos)), key=tempos.__getitem__)
    series = {}
    for j, nome in enumerate(cabecalho):
        if j == indice:
            continue
        valores = []
        invalida = False
        for linha in validas:
            texto = linha[j].strip()
            if texto.lower() in ('', 'nan', 'na', 'null', 'none'):
                valores.append(float('nan'))
                continue
            try:
                valor = numero(texto)
                valores.append(valor if math.isfinite(valor) else float('nan'))
            except ValueError:
                invalida = True
                break
        if invalida or not any(math.isfinite(v) for v in valores):
            print(f'  Ignorada coluna não numérica ou sem valores válidos: {nome}')
            continue
        series[nome] = [valores[i] for i in ordem]
    print(f'{caminho.name}: separador={delimitador!r}, registros={len(linhas)}, variáveis={list(series)}')
    return [tempos[i] for i in ordem], series


def criar_pagina_interativa(graficos, destino):
    """Cria uma página local sem dependências externas, com zoom e pan."""
    dados = []
    for titulo, tempo, nome, valores in graficos:
        dados.append({
            'titulo': titulo,
            'variavel': nome,
            'tempo': tempo,
            'valores': [v if math.isfinite(v) else None for v in valores],
        })
    dados_json = json.dumps(dados, separators=(',', ':')).replace('<', r'\u003c')
    pagina = f'''<!doctype html>
<meta charset="utf-8">
<title>Gráficos interativos</title>
<style>
body {{ font: 14px system-ui, sans-serif; max-width: 1200px; margin: 24px auto; padding: 0 16px; color: #1f2937; }}
h1 {{ margin-bottom: 4px; }} p {{ color: #4b5563; }}
.plot {{ margin: 28px 0; }} .plot h2 {{ font-size: 17px; margin-bottom: 8px; }}
canvas {{ width: 100%; height: 390px; border: 1px solid #cbd5e1; touch-action: none; cursor: grab; }}
canvas.dragging {{ cursor: grabbing; }} button {{ padding: 7px 10px; cursor: pointer; }}
</style>
<h1>Gráficos interativos</h1>
<p>Roda do mouse: zoom. Arrastar: mover. Cada gráfico tem uma escala independente.</p>
<button id="reset">Restaurar zoom</button><div id="plots"></div>
<script>
const charts = {dados_json};
const host = document.getElementById('plots');
const bounds = values => {{
  let lo=Infinity, hi=-Infinity; for (const v of values) {{ if(Number.isFinite(v)) {{lo=Math.min(lo,v);hi=Math.max(hi,v);}} }}
  const pad = (hi - lo || Math.abs(hi) || 1) * .06; return [lo - pad, hi + pad];
}};
charts.forEach((c, index) => {{ c.homeX = bounds(c.tempo); c.homeY = bounds(c.valores); c.x = [...c.homeX]; c.y = [...c.homeY];
  const block = document.createElement('section'); block.className = 'plot';
  const heading=document.createElement('h2'); heading.textContent=c.titulo+' — '+c.variavel;
  block.appendChild(heading); const surface=document.createElement('canvas');
  surface.setAttribute('aria-label',c.variavel+' ao longo do tempo'); block.appendChild(surface);
  host.appendChild(block); const canvas = block.querySelector('canvas'); const ctx = canvas.getContext('2d');
  const box = () => {{ const dpr = devicePixelRatio || 1, r = canvas.getBoundingClientRect(); canvas.width = r.width*dpr; canvas.height = r.height*dpr; ctx.setTransform(dpr,0,0,dpr,0,0); return r; }};
  const draw = () => {{ const r=box(), L=72,R=20,T=22,B=50,W=r.width-L-R,H=r.height-T-B;
    const px=x => L+(x-c.x[0])*W/(c.x[1]-c.x[0]); const py=y => T+(c.y[1]-y)*H/(c.y[1]-c.y[0]);
    ctx.fillStyle='white';ctx.fillRect(0,0,r.width,r.height); ctx.strokeStyle='#e2e8f0'; ctx.lineWidth=1;
    for(let i=0;i<=5;i++) {{ const x=L+W*i/5,y=T+H*i/5; ctx.beginPath();ctx.moveTo(x,T);ctx.lineTo(x,T+H);ctx.stroke();ctx.beginPath();ctx.moveTo(L,y);ctx.lineTo(L+W,y);ctx.stroke(); }}
    ctx.strokeStyle='#475569';ctx.beginPath();ctx.moveTo(L,T);ctx.lineTo(L,T+H);ctx.lineTo(L+W,T+H);ctx.stroke();
    ctx.fillStyle='#334155';ctx.font='12px system-ui';ctx.textAlign='center';
    for(let i=0;i<=5;i++) {{ const v=c.x[0]+(c.x[1]-c.x[0])*i/5;ctx.fillText(v.toPrecision(5),L+W*i/5,T+H+18); }}
    ctx.textAlign='right'; for(let i=0;i<=5;i++) {{ const v=c.y[1]-(c.y[1]-c.y[0])*i/5;ctx.fillText(v.toPrecision(5),L-7,T+H*i/5+4); }}
    ctx.textAlign='center';ctx.fillText('Tempo decorrido (s)',L+W/2,r.height-12);ctx.save();ctx.translate(16,T+H/2);ctx.rotate(-Math.PI/2);ctx.fillText(c.variavel,0,0);ctx.restore();
    ctx.save();ctx.beginPath();ctx.rect(L,T,W,H);ctx.clip();ctx.strokeStyle='#2563eb';ctx.lineWidth=1.15;ctx.beginPath();let active=false;
    for(let i=0;i<c.tempo.length;i++) {{ const x=c.tempo[i],y=c.valores[i]; if(!Number.isFinite(y)){{active=false;continue;}} const a=px(x),b=py(y); if(active)ctx.lineTo(a,b);else{{ctx.moveTo(a,b);active=true;}} }} ctx.stroke();ctx.restore();
  }};
  c.draw=draw;
  const filename=String(index+1).padStart(2,'0')+'_'+(c.titulo+'_'+c.variavel).replace(/[^a-zA-Z0-9_.-]/g,'_');
  const download=(blob,ext)=>{{const url=URL.createObjectURL(blob),a=document.createElement('a');a.href=url;a.download=filename+ext;a.click();setTimeout(()=>URL.revokeObjectURL(url),1000);}};
  const button=(label,action)=>{{const b=document.createElement('button');b.textContent=label;b.onclick=action;block.appendChild(b);}};
  button('Exportar PNG (vista atual)',()=>{{draw();canvas.toBlob(blob=>{{if(blob)download(blob,'.png');}},'image/png');}});
  button('Exportar CSV (série completa)',()=>{{
    const quote=v=>String(v).includes('"')||/[;,\\n\\r]/.test(String(v))?'"'+String(v).replaceAll('"','""')+'"':String(v);
    const rows=[['tempo_decorrido_s',c.variavel].map(quote).join(',')];
    c.tempo.forEach((t,i)=>rows.push(t+','+(c.valores[i]===null?'':c.valores[i])));
    download(new Blob([rows.join('\\r\\n')+'\\r\\n'],{{type:'text/csv;charset=utf-8'}}),'.csv');
  }});
  button('Restaurar este gráfico',()=>{{c.x=[...c.homeX];c.y=[...c.homeY];draw();}});
  let last; canvas.addEventListener('pointerdown', e => {{ last=[e.offsetX,e.offsetY];canvas.setPointerCapture(e.pointerId);canvas.classList.add('dragging'); }});
  canvas.addEventListener('pointermove', e => {{ if(!last)return;const r=canvas.getBoundingClientRect(), L=72,R=20,T=22,B=50,W=r.width-L-R,H=r.height-T-B;const dx=(e.offsetX-last[0])*(c.x[1]-c.x[0])/W,dy=(e.offsetY-last[1])*(c.y[1]-c.y[0])/H;c.x[0]-=dx;c.x[1]-=dx;c.y[0]+=dy;c.y[1]+=dy;last=[e.offsetX,e.offsetY];draw(); }});
  canvas.addEventListener('pointerup', () => {{last=null;canvas.classList.remove('dragging');}});
  canvas.addEventListener('pointercancel', () => {{last=null;canvas.classList.remove('dragging');}});
  canvas.addEventListener('wheel', e => {{e.preventDefault();const r=canvas.getBoundingClientRect(), L=72,R=20,T=22,B=50,W=r.width-L-R,H=r.height-T-B;const fx=Math.max(0,Math.min(1,(e.offsetX-L)/W)),fy=Math.max(0,Math.min(1,(e.offsetY-T)/H)),scale=e.deltaY<0?.8:1.25;const zx=(c.x[1]-c.x[0])*scale,zy=(c.y[1]-c.y[0])*scale;const cx=c.x[0]+fx*(c.x[1]-c.x[0]),cy=c.y[1]-fy*(c.y[1]-c.y[0]);c.x=[cx-fx*zx,cx+(1-fx)*zx];c.y=[cy-(1-fy)*zy,cy+fy*zy];draw();}},{{passive:false}});
  new ResizeObserver(draw).observe(canvas); draw();
}});
document.getElementById('reset').onclick=()=>{{charts.forEach(c=>{{c.x=[...c.homeX];c.y=[...c.homeY];c.draw();}});}};
</script>'''
    destino.parent.mkdir(parents=True, exist_ok=True)
    destino.write_text(pagina, encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('arquivos', nargs='*', type=Path,
                        default=[Path(nome) for nome in ('ot1_manager_to_attitude.csv', 'ot1_manager_to_vel.csv', 'ot1_rudder_angle_rad.csv', 'ot1_propeller_rpm.csv')])
    parser.add_argument('--exportar-csv', type=Path, metavar='PASTA', help='Exportar tempo_decorrido_s + variável, uma série por CSV.')
    parser.add_argument('--tempo', default='timestamp', help='Nome da coluna de tempo.')
    parser.add_argument('--unidade-tempo', choices=['s', 'ms', 'us', 'ns'], default='us')
    parser.add_argument('--salvar', type=Path, metavar='PASTA', help='Salvar uma imagem PNG por variável.')
    parser.add_argument('--saida-html', type=Path, default=Path('graficos_interativos.html'),
                        help='Arquivo HTML interativo a criar (padrão: graficos_interativos.html).')
    parser.add_argument('--sem-exibir', action='store_true', help='Criar o HTML, mas não abri-lo no navegador.')
    args = parser.parse_args()
    if args.saida_html.resolve() in {v.resolve() for v in args.arquivos}:
        parser.error('--saida-html não pode sobrescrever um CSV original.')
    plt = None
    if args.salvar:
        import matplotlib
        matplotlib.use('Agg')
        import matplotlib.pyplot as plt
    escala = {'s': 1, 'ms': 1000, 'us': 1000000, 'ns': 1000000000}[args.unidade_tempo]
    if args.salvar:
        args.salvar.mkdir(parents=True, exist_ok=True)
    if args.exportar_csv:
        args.exportar_csv.mkdir(parents=True, exist_ok=True)
    falhas = 0
    graficos = []
    for n, caminho in enumerate(args.arquivos, 1):
        try:
            tempos, series = carregar(caminho, args.tempo)
            if not series:
                raise ValueError('Nenhuma variável numérica para plotar.')
            t = [(v - tempos[0]) / escala for v in tempos]
            for j, (nome, valores) in enumerate(series.items(), 1):
                graficos.append((caminho.stem, t, nome, valores))
                seguro = re.sub(r'[^\w.-]+', '_', f'{caminho.stem}_{nome}')
                if args.exportar_csv:
                    destino_csv = args.exportar_csv / f'{n:02d}_{j:02d}_{seguro}.csv'
                    if destino_csv.resolve() in {v.resolve() for v in args.arquivos}:
                        raise ValueError('Destino de exportação coincide com CSV original.')
                    with destino_csv.open('w', encoding='utf-8', newline='') as arquivo:
                        writer = csv.writer(arquivo)
                        writer.writerow(['tempo_decorrido_s', nome])
                        writer.writerows((x, y if math.isfinite(y) else '') for x, y in zip(t, valores))
                    print(f'  CSV: {destino_csv}')
                if not args.salvar:
                    continue
                fig, ax = plt.subplots(figsize=(10, 4.5), layout='constrained')
                if nome.endswith('_active'):
                    ax.step(t, valores, where='post', linewidth=1)
                    ax.set_yticks([0, 1])
                else:
                    ax.plot(t, valores, linewidth=1)
                ax.set(title=f'{caminho.stem} — {nome}', xlabel='Tempo decorrido (s)', ylabel=nome)
                ax.grid(True, alpha=0.3)
                if args.salvar:
                    seguro = re.sub(r'[^\w.-]+', '_', f'{caminho.stem}_{nome}')
                    destino = args.salvar / f'{n:02d}_{j:02d}_{seguro}.png'
                    fig.savefig(destino, dpi=160)
                    print(f'  PNG: {destino}')
                plt.close(fig)
        except (OSError, ValueError, csv.Error) as exc:
            print(f'Erro em {caminho}: {exc}', file=sys.stderr)
            falhas += 1
    if graficos:
        criar_pagina_interativa(graficos, args.saida_html)
        print(f'  Gráficos interativos: {args.saida_html.resolve()}')
        if not args.sem_exibir:
            webbrowser.open(args.saida_html.resolve().as_uri())
    return 1 if falhas else 0


if __name__ == '__main__':
    sys.exit(main())
