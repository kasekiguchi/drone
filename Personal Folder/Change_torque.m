%4入力を総推力+トルクに変換する関数

function torque = Change_torque(param, u)
    Lx = param.Lx;
    Ly = param.Ly;
    lx = param.lx;
    ly = param.ly;
    km1 = param.km1;           
    km2 = param.km2;           
    km3 = param.km3;           
    km4 = param.km4;           
    IT = [1 1 1 1;-ly, -ly, (Ly - ly), (Ly - ly); lx, -(Lx-lx), lx, -(Lx-lx); km1, -km2, -km3, km4];
    torque = IT*u;
end