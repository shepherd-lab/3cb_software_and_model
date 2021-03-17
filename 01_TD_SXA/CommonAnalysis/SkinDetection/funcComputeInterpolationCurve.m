function Curve=funcComputeInterpolationCurve(ManualEdge)

param = 1:ManualEdge.NumberPoints;
listparam=[1:(ManualEdge.NumberPoints-1)/100:ManualEdge.NumberPoints];
ManualEdgeX = spline(param',ManualEdge.Points(:,1),listparam);
ManualEdgeY = spline(param',ManualEdge.Points(:,2),listparam);    

Curve=[ManualEdgeX' ManualEdgeY'];
   