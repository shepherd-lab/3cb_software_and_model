function result=funcclim(image,limmin,limmax);

result=image;
maskminus=result<limmin;
maskplus=result>limmax;
result=result+(maskminus).*(limmin-result);
result=result+(maskplus).*(limmax-result);

