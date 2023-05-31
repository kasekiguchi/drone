SimBaseMode = ["","SimHL","SimVoronoi2D"];
ExpBaseMode = ["","ExpHL","ExpVoronoi2D"];
gui = SimExp;
%%
gui.PlantLabel.Text = ["Plant ",""];
gui.Lamp.Color = [1 0 0];
gui.LampLabel.Text = "Arming";
gui.RunmodeListBox.Value = "Simulation";

%%
hoge = readcell("test.csv");