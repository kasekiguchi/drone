classdef (Abstract) CONNECTOR_CLASS < handle
    % Connector クラス
    %   センサーとの違いはデータの送受信があるかどうか．：ROSやWifiなどは双方向通信
    %   機体依存かどうか　：Prime はglobal情報で機体依存ではない
    %  サブクラスではgetData(packet), sendData(packet) どちらか，または両方を実装する必要がある．
    properties
       % data
    end
    
    methods (Abstract)
       % getData(obj);
       % sendData(obj);
    end
end
