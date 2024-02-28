%function post_load_function()
mybus = Simulink.Bus;
el1=Simulink.BusElement; 
el1.Name = 'a';
el2=Simulink.BusElement; 
el2.Name = 'b';
mybus.Elements = [el1 el2];

myOutBus= Simulink.Bus;
el1=Simulink.BusElement; 
el1.Name = 'sum';
el2=Simulink.BusElement; 
el2.Name = 'prod';
el3=Simulink.BusElement; 
el3.Name = 'diff';
myOutBus.Elements = [el1 el2 el3];
%end
my_Bus = Simulink.Bus;
el1=Simulink.BusElement;
el1.Name = 'bus1';
el1.DataType = 'Bus: myOutBus';
el2=Simulink.BusElement;
el2.Name = 'bus2';
el2.DataType = 'Bus: mybus';
my_Bus.Elements = [el1 el2];