classdef GrammianAnalysis<handle
    
    properties
        step
        dt
        AllLOM
        AllSysF
        AllP
    end
    
    methods
        function obj = GrammianAnalysis(te,ts,dt)
            %constructer
            obj.dt = dt;
            obj.step = 0;
            obj.AllLOM = cell(1,round((te-ts)/dt) + 1);
            obj.AllSysF = cell(1,round((te-ts)/dt) + 1);
            obj.AllP = cell(1,round((te-ts)/dt) + 2);
        end
        function Obs = LOM(obj,C,A,x)
            %Local obsrevability matrix LOM(obj,C,A,x)
            %             A = zeros(size(x,1),size(x,1));
            %             A(1,3:4)= [-x(4) * sin(x(3)),cos(x(3))];
            %             A(2,3:4)= [-x(4) * cos(x(3)),sin(x(3))];
            %             A(3,5) = 1;
            Obs = [C' , cell2mat(arrayfun(@(n) (C*A^n)' ,1:size(x)-1,'UniformOutput' ,false))]';
            obj.AllLOM{1,obj.step} = Obs;
        end
        
        function [Obs] = TOM(obj)
            %Total obsrvability matrix
            Obs = obj.AllLOM{1};
            i=2;j = 2;
            while i<=obj.step
                tmpObs =obj.AllLOM{1,i};
                while j<=i
                    tmpObs=tmpObs*exp(obj.AllSysF{j-1} * obj.dt);
                    j=j+1;
                end
                Obs = [Obs;tmpObs];
                i=i+1;j=2;
            end
            
        end
        
        function [Gram,EGramVec] = Grammian(obj,O)
            Gram = O'*O;
            [~,EGramVec] = eig(Gram);
            
        end
        
        function UpdateT(obj)
            obj.step = obj.step+1;
        end
        
        function SaveSys(obj,A)
            obj.AllSysF{1,obj.step} = A;
        end
        
        function SaveP(obj,P)
            obj.AllP{1,obj.step+1} = P;
        end
        
        function result = InFo(obj)
            n = size(obj.AllP{1,obj.step},1);
            nn = size(obj.AllP{1,obj.step-1},1);
            ax = (n/2) * (1+ log(2*pi)) + (1/2) * log(det(obj.AllP{1,obj.step}));
            x = (nn/2) * (1+ log(2*pi)) + (1/2) * log(det(obj.AllP{1,obj.step-1}));
            result = x - ax;
        end
        
        function Obs = LinearGram(obj,x,psi)
            Handle = arrayfun(@(n) str2func(strcat('Ldim',num2str(n))) , 0:size(x) -1,'UniformOutput', false);
            Obs = arrayfun(@(n) Handle{1,n}(x(1), x(2), x(3), x(4),x(5),psi()) , 1:size(x) , 'UniformOutput' , false);
        end
        
    end
    
end

