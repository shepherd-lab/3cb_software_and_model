function result=funcDXAcompute(imageHE,imageLE);

result=(imageLE-16000)./(imageHE-6000);
maskminus=result<0;
maskplus=result>2;
result=result.*(-maskminus+1);
result=result+(maskplus).*(2-result);

