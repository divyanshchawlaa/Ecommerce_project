library(caret)
library(pROC)

# Define high-value invoices (top 20% AOV)
high_thr <- quantile(invoice_summary$aov, 0.8)
invoice_summary <- invoice_summary %>% mutate(high_value = aov >= high_thr)

# Train-test split (70% train, 30% test)
set.seed(42)
train_index <- createDataPartition(invoice_summary$high_value, p=0.7, list=FALSE)
train <- invoice_summary[train_index, ]
test <- invoice_summary[-train_index, ]

# Logistic regression model
glm_model <- glm(high_value ~ log1p(aov) + is_weekend,
                 data=train,
                 family=binomial)

# Model summary
summary(glm_model)

# Predictions on test set
preds <- predict(glm_model, newdata=test, type="response")

# ROC curve & AUC
roc_obj <- roc(as.numeric(test$high_value), preds)
auc_val <- auc(roc_obj)
auc_val  # Print AUC

# Confusion matrix
pred_class <- factor(ifelse(preds >= 0.5, 1, 0), levels=c(0,1))
ref <- factor(ifelse(test$high_value, 1, 0), levels=c(0,1))
cm <- confusionMatrix(pred_class, ref, positive="1")
cm

