# Computer-Aided-Manufacturing-Programm-for-2.5D-Laser-Ablation-Version-2.0

Computer Aided Manufacturing Program for 2.5D Laser Ablation

I programmed this Matlabcode as part of my bachelor, semester and master thesis at the ETH university in 2015, 2016 and 2017. These programs can calculate the trajectories for laser production from the three-dimensional geometry (stl-file) of the desired workpiece. These trajectories can be saved as g-code, which can be adjusted in the program for different laser processing machines. Further informations can be found in the theses papers, which are attached as a pdf-file. The theses, the GUI and all comments in the code are written in german.

The source code can be executed with Matlab. Make sure, that you download all files and put them in the same folder. To start the LaserCAM GUI for 2.5D laser ablation of cartesian workpieces, you have to execute the main file: 'LaserCAMkartesisch.m'. If you want to start the LaserCAM GUI for 2.5D laser ablation of cylindrical workpieces, you have to execute the main file: 'LaserCAMzylindrisch.m'. If you want to start the LaserCAM GUI for tangential laser processing you have to execute the main file: 'LaserCAMtangential.m'.

If you don't have Matlab, you can start the GUIs directly with the Matlab compiled versions: 'LaserCAMkartesich.exe',  'LaserCAMzylindrisch.exe' or 'LaserCAMtangential.exe'. This only works if you have Matlab Compiler Runtime (MCR) installed. You can install a working Matlab Compiler Runtime with the file 'MyAppInstaller_web.exe'.

If you want to do analysis or further development of the program I suggest to start with the Matlabscripts "HauptprogrammKar.m", "HauptprogrammZyl.m" or "HauptprogrammTan.m". This scripts have no GUI but do the same calculations, are more structured and easier to understand.
