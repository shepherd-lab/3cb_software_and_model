Molybdenum(:,1)=Molybdenum(:,1)*1000;
InterMoly=interp1(Molybdenum(:,1),Molybdenum(:,2),energies,'pchip');
InterFat=interp1(Adipous(:,1),Adipous(:,2),energies,'pchip');
InterBreast=interp1(Breast(:,1),Breast(:,2),energies,'pchip');
InterCopper=interp1(Copper(:,1),Copper(:,2),energies,'pchip');
InterAlu=interp1(Aluminum(:,1),Aluminum(:,2),energies,'pchip');



coefRhodium=[...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
+0.000000e+000,+0.000000e+000,+0.000000e+000,+0.000000e+000;...
-1.192045e+005,+1.367483e+004,-1.778029e+002,+0.000000e+000;...
-1.530890e+005,+2.993084e+004,-3.532862e+002,+0.000000e+000;...
-4.149003e+005,+8.345416e+004,-1.083803e+003,+0.000000e+000;...
-2.110957e+006,+3.086459e+005,-6.845642e+003,+5.278299e+001;...
-2.895965e+006,+4.286116e+005,-8.011144e+003,+5.426242e+001;...
-5.555697e+006,+7.440265e+005,-1.642142e+004,+1.359430e+002;...
-6.230149e+006,+8.173703e+005,-1.611456e+004,+1.222256e+002;...
-6.721657e+006,+8.681462e+005,-1.532193e+004,+1.103395e+002;...
-9.068231e+006,+1.096678e+006,-2.023126e+004,+1.549885e+002;...
-8.560903e+006,+1.021060e+006,-1.534351e+004,+9.531149e+001;...
-9.932459e+006,+1.131318e+006,-1.756427e+004,+1.235573e+002;...
-8.539150e+006,+9.150594e+005,-7.607820e+003,+0.000000e+000;...
-1.230498e+007,+1.299176e+006,-2.007492e+004,+1.400943e+002;...
-1.258838e+007,+1.281049e+006,-1.888631e+004,+1.459051e+002;...
-1.117718e+007,+1.123389e+006,-1.388007e+004,+9.606536e+001;...
-1.341985e+007,+1.322989e+006,-2.081445e+004,+1.790645e+002;...
-1.165702e+007,+1.092111e+006,-1.302265e+004,+9.547466e+001;...
-9.828931e+006,+8.537916e+005,-4.495113e+003,+0.000000e+000;...
-1.315013e+007,+1.166460e+006,-1.522815e+004,+1.211643e+002;...
-1.055732e+007,+8.516584e+005,-4.450458e+003,+0.000000e+000;...
-1.226238e+007,+9.997632e+005,-9.875705e+003,+6.619936e+001;...
-1.138493e+007,+8.582543e+005,-4.631944e+003,+0.000000e+000;...
-1.421375e+007,+1.145459e+006,-1.533291e+004,+1.259442e+002;...
-9.209721e+006,+5.087933e+005,+8.598628e+003,-1.587797e+002;...
-1.549092e+007,+1.206348e+006,-1.766176e+004,+1.532736e+002;...
-1.932713e+007,+1.607190e+006,-3.258084e+004,+3.306037e+002;...
-1.655464e+007,+1.245415e+006,-2.068765e+004,+2.442210e+002;...
-1.425125e+007,+9.396121e+005,-9.776435e+003,+1.238981e+002;...
-1.815094e+007,+1.364727e+006,-2.403874e+004,+2.285077e+002;...
-1.216617e+007,+7.156276e+005,-2.695818e+003,+0.000000e+000;...
-2.145288e+007,+1.616216e+006,-3.195334e+004,+3.094406e+002;...
-2.414743e+006,-3.452748e+005,+2.379756e+004,+0.000000e+000;...
+3.003396e+008,-3.075391e+007,+9.339644e+005,-7.017946e+003;...
+5.462775e+006,-1.213200e+006,+5.677435e+004,-4.994289e+002;...
-2.351651e+007,+1.690655e+006,-3.414655e+004,+3.187491e+002;...
-2.467444e+007,+1.753499e+006,-3.541516e+004,+3.220338e+002;...
-1.450545e+007,+7.268329e+005,-3.060708e+003,+0.000000e+000;...
+3.578927e+007,-4.382693e+006,+1.475727e+005,-1.066008e+003;...
-1.096621e+007,+3.159859e+005,+6.759924e+003,+0.000000e+000;...
-1.482286e+007,+7.697687e+005,-5.920930e+003,+0.000000e+000;...
-1.353926e+007,+6.892985e+005,-4.922390e+003,+0.000000e+000;...
-1.585640e+007,+8.193523e+005,-6.915169e+003,+0.000000e+000;...
-2.091730e+007,+1.281929e+006,-2.166006e+004,+1.561249e+002;...
-1.682020e+007,+8.387164e+005,-7.058292e+003,+0.000000e+000;...
-1.371139e+007,+6.412199e+005,-4.135089e+003,+0.000000e+000;...
-1.317428e+007,+5.910486e+005,-3.312845e+003,+0.000000e+000;...
-1.527150e+007,+7.058618e+005,-5.108053e+003,+0.000000e+000;...
-1.893962e+007,+8.966009e+005,-7.635881e+003,+0.000000e+000;...
-1.501063e+007,+6.731629e+005,-4.715857e+003,+0.000000e+000;...
-1.677653e+007,+7.439650e+005,-5.437238e+003,+0.000000e+000;...
-1.554349e+007,+6.616319e+005,-4.284524e+003,+0.000000e+000;...
-2.030067e+007,+9.246585e+005,-8.056714e+003,+0.000000e+000;...
-2.059148e+007,+9.300864e+005,-8.139347e+003,+0.000000e+000;...
-1.812410e+007,+7.722229e+005,-5.847742e+003,+0.000000e+000;...
-1.698671e+007,+7.030718e+005,-4.949130e+003,+0.000000e+000;...
-1.091269e+007,+3.485818e+005,+0.000000e+000,+0.000000e+000;...
-1.862237e+007,+7.666374e+005,-5.758571e+003,+0.000000e+000;...
-1.053842e+007,+3.292848e+005,+0.000000e+000,+0.000000e+000;...
-2.136943e+007,+8.979092e+005,-7.560643e+003,+0.000000e+000;...
-1.962580e+007,+7.851751e+005,-5.951071e+003,+0.000000e+000;...
-1.086196e+007,+3.225121e+005,+0.000000e+000,+0.000000e+000;...
-2.630957e+007,+1.132011e+006,-1.068638e+004,+0.000000e+000;...
-1.119069e+007,+3.212166e+005,+0.000000e+000,+0.000000e+000;...
-1.796286e+007,+6.417951e+005,-3.830313e+003,+0.000000e+000;...
-1.129583e+007,+3.160500e+005,+0.000000e+000,+0.000000e+000;...
-1.254071e+007,+3.441640e+005,+0.000000e+000,+0.000000e+000;...
-1.238993e+007,+3.357620e+005,+0.000000e+000,+0.000000e+000;...
-1.180338e+007,+3.155950e+005,+0.000000e+000,+0.000000e+000;...
-9.228471e+006,+2.500255e+005,+0.000000e+000,+0.000000e+000;...
-1.315735e+007,+3.420035e+005,+0.000000e+000,+0.000000e+000;...
-1.271111e+007,+3.264835e+005,+0.000000e+000,+0.000000e+000;...
-1.352841e+007,+3.425655e+005,+0.000000e+000,+0.000000e+000;...
-1.338335e+007,+3.333319e+005,+0.000000e+000,+0.000000e+000;...
-1.414444e+007,+3.479542e+005,+0.000000e+000,+0.000000e+000;...
-1.537484e+007,+3.736247e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,+0.000000e+000,+0.000000e+000;...
-1.716400e+007,+4.120892e+005,0,0];
    