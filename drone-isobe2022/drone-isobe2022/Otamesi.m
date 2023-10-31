clear all;
clc;
test1=ros2node("\test1",30);

scandala_Sub=ros2subscriber(test1,"/scan","History","keepall","Reliability","besteffort");
scandala=receive(scandata_Sub,2);
movingPC = rosReadCartesian(scandala);
pcshow(movingPC,"MarkerSize",12,"BackgroundColor",[1 1 1]);