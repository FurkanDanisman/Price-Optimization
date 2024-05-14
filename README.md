# Price-Optimization

In this project, prices regarding the actual supermarket sales were collected.

Through machine learning, with the xgboost model and optimized functions in R, the optimal price range tried to be estimated for the maximum profit. Considering different behaviours with specific price ranges, this was an interesting study. 

It has been found that prices were categorized under two sections: economic and above-economic. Economic prices had a concave down shape, and the optimal point was easy to find through the optimize function. However, for the above-economic, prices and profits had a strongly linear relationship, which indicates as the prices go up, profits go up. This possibly tells us we are missing some confounding factors in our data. It can be as simple as expensive materials that target audiences who do not mind paying a bit higher. As a result, as the price goes higher, after some point, profit would increase. We can observe a similar idea in restaurants. Some dishes are made from identical materials. But it would be cheaper in one local small restaurant, and the profit would be less. Whereas in a fancy restaurant, the same dish with the same materials would be highly expensive, corresponding to higher profit. Hence, this study is open for further investigation. 
