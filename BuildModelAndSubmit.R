#Have only required features for the model.

nam = names(traincyc)

Omit = c (which(nam == "casual"),which(nam== "count"),which(nam=="registered")
          ,which(nam=="datetime"))

Omitactual = c(Omit,which(nam=="temp"),which(nam=="atemp"),which(nam=="windspeed"),which(nam=="humidityn"),which(nam=="humidity"))



#Build the GBm model
cyclelogcount.gbm = gbm(logcount~.,
                        data =traincyc[,-Omitactual],
                        distribution="gaussian",
                        keep.data=F,
                        verbose=F,
                        n.cores=1,
                        n.trees=5000,
                        shrinkage=.1,
                        interaction.depth=9,
                        n.minobsinnode=20,
                        bag.fraction = .5,
                        cv.folds=3
)
# 
# P_logcount.train = cyclelogcount.gbm$fit
# P_count.train = exp(1)^P_logcount.train -1
# lrmse.gbmlog = sum(((log(P_count.train+1) - log(traincyc$count+1))^2)^.5)/nrow(traincyc) 

#Predict for test data
p_logcount_test = predict(cyclelogcount.gbm,test,type="response")
#convert the logcount to count.
p_count_test = exp(1)^p_logcount_test -1


#Create a submission dataframe and write to a csv file
submission = data.frame(Datetime=test$datetime,Count=p_count_test)
write.csv(submission,file="submissionTest.csv",quote=F,row.names=F)
