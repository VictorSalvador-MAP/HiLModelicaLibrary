# :anchor: How to use Aquanaut on OpenModelica

OpenModelica can be installed by following the instructions described in the [official website](https://openmodelica.org), acoording to your operating system. 

The modelica standard Library used by OpenModelica must be **version 4.0.0** or higher. 

To use Aquanaut, the first step is to rename the folder `Analysis` to `Aquanaut`, since every modelica file inside the package reference a folder with this name. 

In OpenModelica, select **Tools** in the upper menu bar, then click **Options**. A pop-up window will appear. Navigate to 'Libraries'. 
Under "User libraries loaded automatically on startup *", click **Add**. Another window will pop. Navigate to **Aquanaut** (renamed folder) and select the **package.mo** file. 

Note that there are multiple 'package.mo' files in the folder structure. Each folder contains its own 'package.mo', which describes that specific package. Since the entire Aquanaut package must be loaded, make sure to select the 'package.mo' located in the highest level of the folder hierarchy inside Aquanaut directory. 

<img width="1300" height="541" alt="image" src="https://github.com/user-attachments/assets/693b97d6-7274-4636-abda-687b7d24d98a" />

Confirm your choices clicking in 'ok', then reset OpenModelica. 

The next time it opens, Aquanaut Library must be shown aside the Standard Modelica Library. 

<img width="200" height="201" alt="image" src="https://github.com/user-attachments/assets/b15be030-c854-4d24-8988-2b4a9e11928e" />
