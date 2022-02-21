# Gold-Price-Prediction--Time-series-analysis

Objective:

1.To predict the future monthly average price of gold using time series.

2.To check the seasonality ,and trend as per the historic data.

3.To create a model using Time Series Arima . 

4.To check the performance of the model using certain performance measures .

5.Residual Analysis and Forecasting.

Analysis:

1. Data split between test and train in 70:30 ratio.

2. Trend and seasonality decomposition (additive and multiplicative) done  which shows there is strong trend but not very clear seasonality.

3. Seasonality plots and spiral plot to dig more in seasonality.

4. Boxplot shows there is no difference in the means of months. P value is >0.05, which indicates there is no diffence in means of months.

<img src="https://user-images.githubusercontent.com/99994988/154946361-352234b1-34f8-4033-a3a6-9a68b19a7799.png" width="400" height="300" align="right">

<img src="https://user-images.githubusercontent.com/99994988/154946195-3efb596c-d9d2-416e-ab44-69449583dfa6.png" width="400" height="300" >



Forecasting:

1. Holt Winter Linear Method as there is a sharp increasing trend in the gold price of this dataset.

<img src="https://user-images.githubusercontent.com/99994988/154945715-9c851b30-e8ff-4608-bcd3-4b7aff6d1abf.png" width="400" height="300">


2. Manual ARIMA: ADF test done to check if the data is stationary.Differencing is done once to make it stationary.ARIMA done for (0,1,1),(0,1,0),(1,1,0).
   the lowest AIC is for p=0, d=1,q=1. Residuals are also normally distributed.
   
3. AUTO ARIMA also shows the same result.

<img src="https://user-images.githubusercontent.com/99994988/154944945-8301da75-bf65-4379-a2fc-8fd600ae8880.png" width="400" height="300">


Performance Comparison:

Linear Holt winter model has the lowest RMSE,MAE,MAPE,MASE

Conclusion and Forecast:

Linear Holt Winter wins over Arima Model as it has the better accuracy for this dataset. 

<img src="https://user-images.githubusercontent.com/99994988/154946669-8147b7ed-ef25-4d4b-b127-de2922c16d85.png" width="400" height="300">












