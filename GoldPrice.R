install.packages("forecast")
install.packages("tseries")
install.packages("zoo")
install.packages("fpp2")
install.packages("fpp3")
install.packages("fable")

Gold=Gold1%>%
  select(Price)
Gold2=Gold1%>%
    mutate(month = month(date))
View(Gold2)
tble_anv=Gold2%>%
  select(month,Price)%>%
  group_by(month)%>%
  summarise(Price=sum(Price))

View(tble_anv)

tble_anv$month=as.factor(tble_anv$month)
table=aov(Price~month,data=tble_anv)
summary(table)
ggplot(Gold2,aes(x=month,y=Price))+geom_boxplot(width=0.7)
 
   
  
  
  
  
  
str(Gold)
summary(Gold)

##Split Data in test and train
goldts=ts(Gold,start=1979,frequency=12)
plot(goldts)
title(main="Gold Price in AED per troy ounce")
gold_new=window(goldts,start=2000, end=c(2021,9))
attributes(goldts)
train= window(gold_new, start=2000, end=c(2019,12))
test=window(gold_new, start=2020) 
View(gold_new)

plot(gold_new)
title(main="Gold Price in AED per troy ounce")

##Decomposition

autoplot(decompose(gold_new,type="multiplicative"))
autoplot(decompose(gold_new,type="additive"))
##Seasonal Plot
ggseasonplot(gold_new, year.labels=TRUE, year.labels.left=TRUE) +  ylab("price") +
  ggtitle("Seasonal plot:  Gold Price")

## Seasonal Plot
seasonplot(gold_new,xlab = "",col = c("red", "blue"),year.labels = T,labelgap = 0.45,type = "l",main = "Seasonal plot of Gold Price")

## Polar Seasonal Plot
ggseasonplot(gold_new, polar=TRUE) + ylab(" Gold Price in AED")

## BoxPlot for seasonality
boxplot(gold_new~cycle(gold_new)) 

table=aov(Price~cycle(gold_new),data=gold_new)
summary(table)

##Subseries Plot
ggsubseriesplot(gold_new)

ggAcf(gold_new,lag.max = 12)
### 1..Naive model

naive = snaive(train, h=length(test))
accuracy(naive,test)
plot(gold_new, col="blue", xlab="Year", ylab="Gold Price", main="Seasonal Naive Forecast", type='l')
lines(naive$mean, col="red", lwd=2)
######





###2.. DS HOLT WINTER
dshw_model = dshw(train,period1=4, period2 = 12,h=length(test))
accuracy(dshw_model,test)
summary(dshw_model)
plot(gold_new, col="blue", xlab="Year", ylab="Gold Price", main="Holt Winter Forecast", type='l')
lines(dshw_model$mean, col="red", lwd=2)

###3.Holt Linear Method


HW1=HoltWinters(train)
summary(HW1)
plot(train, ylab="Gold Price")
lines(HW1$fitted[,1], lty=2, col="blue")
title("Linear Holt Winter")

HW1.pred <- predict(HW1, 36, prediction.interval = TRUE, level=0.95)
#Visually evaluate the prediction
plot(train, ylab="Gold Price")
lines(HW1$fitted[,1], lty=2, col="blue")
lines(HW1.pred[,1], col="red")
lines(HW1.pred[,2], lty=2, col="orange")
lines(HW1.pred[,3], lty=2, col="orange")
title("Linear Holt Winter")
HW1_for=forecast(HW1, h=36, level=c(80,95))
accuracy(HW1_for,test)
plot(HW1_for)
lines(HW1_for$fitted, lty=2, col="purple")

acf(HW1_for$residuals, lag.max=20, na.action=na.pass)
Box.test(HW1_for$residuals, lag=20, type="Ljung-Box")
hist(HW1_for$residuals)

data=data.frame(Actual=test$Price,Predicted=HW1_for$fitted)
head(data)


##4.Manual ARIMA
##Stationary Check
adf.test(train)
##p-value is greater than 0.05, therefore ts is non stationary
ndiffs(train)
##1
nsdiffs(train)
##0
ggtsdisplay(diff(train))

gold_new_d1=diff(train,differences=1)
adf.test(gold_new_d1,k=12)
##p=value after difference in <0.05,therefore now the time series is stationary.
autoplot(gold_new_d1)
##therefore d=1
Pacf(gold_new_d1)
##p=1
Acf(gold_new_d1)
##q=1
MA_model=Arima(gold_new_d1, order=c(2, 1, 3))
MA_model
MA_model=Arima(gold_new_d1, order=c(1, 1, 3))
MA_model
MA_model=Arima(gold_new_d1, order=c(1, 1, 0))
MA_model
checkresiduals(MA_model)
Forecast=forecast(MA_model)
accuracy(Forecast,test)
plot(myForecast)
MA_model=Arima(gold_new_d1, order=c(0, 1, 1))
MA_model
MA_model=Arima(gold_new_d1, order=c(0, 1, 0))
MA_model


### 4. Arima

model=auto.arima(train,seasonal=FALSE,stepwise = FALSE,approximation = FALSE)
model
acf(ts(model$residuals))
pacf(ts(model$residuals))
checkresiduals(model)
myForecast=forecast(model,level=c(95),h=36)
plot(myForecast)
accuracy(myForecast,test)
Box.test(myForecast$residuals,lag=15,type="Ljung-Box")
Box.test(myForecast$residuals,lag=20,type="Ljung-Box")
Box.test(myForecast$residuals,lag=30,type="Ljung-Box")
hist(myForecast$residuals)
lines(density(myForecast$residuals))
##ETS
fit=ETS(train)






##################################

## Simple forcasting models
autoplot(train) +autolayer(meanf(train, h=24),series="Mean", PI=FALSE) +  
  autolayer(rwf(train, h=24),series="snaïve", PI=FALSE) +
  autolayer(rwf(train, drift=TRUE, h=24),series="Drift", PI=FALSE) + 
  ggtitle("Gold Price") +  xlab("year") + ylab("Price") + 
  guides(colour=guide_legend(title="Forecast"))

fits=fitted(naive(train))
autoplot(train, series="Data") +
  autolayer(fits, series="Fitted") +  xlab("Year") + ylab("Sales") +
  ggtitle("Gold Price")

##Residuals
res=residuals(naive(train))  
autoplot(res) +  xlab("Day") +  ylab("") +
  ggtitle("Residuals from naïve method")

gghistogram(res, add.normal=TRUE) +  
  ggtitle("Histogram of residuals")

ggAcf(goldts)

train= window(goldts, start=1979, end=c(2019,12))
test=window(goldts, start=2020) 
fit1=meanf(train, h=12)  
fit2=rwf(train, h=12) 
fit3=snaive(train, h=12)


accuracy(fit1, test)
accuracy(fit2, test)
accuracy(fit3, test)











