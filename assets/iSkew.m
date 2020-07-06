function o= iSkew(Om)
tmpOm=(Om-Om')/2;
o=[-tmpOm(2,3),tmpOm(1,3),-tmpOm(1,2)]';
end
