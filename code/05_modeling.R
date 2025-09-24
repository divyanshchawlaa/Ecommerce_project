library(caret)
library(pROC)
library(ggplot2)

# Define high-value invoices (top 20% AOV)
high_thr <- quantile(invoice_summary$aov, 0.8)
invoice_summary <- invoice_summary %>%
  mutate(high_value = aov >= high_thr)

# Train-test split (70% train, 30% test)
set.seed(42)
train_index <- createDataPartition(invoice_summary$high_value, p=0.7, list=FALSE)
train <- invoice_summary[train_index, ]
test <- invoice_summary[-train_index, ]

# Check factor levels
table(train$is_weekend)

# Conditional formula to avoid single-level factor error
if(length(unique(train$is_weekend)) < 2){
  formula_model <- as.formula("high_value ~ log1p(aov)")
} else {
  formula_model <- as.formula("high_value ~ log1p(aov) + is_weekend")
}

# Fit logistic regression
glm_model <- glm(formula_model, data=train, family=binomial)
summary(glm_model)

# Predictions
preds <- predict(glm_model, newdata=test, type="response")

# ROC and AUC
roc_obj <- roc(as.numeric(test$high_value), preds)
auc_val <- auc(roc_obj)
auc_val

# Confusion matrix
pred_class <- factor(ifelse(preds >= 0.5, 1, 0), levels=c(0,1))
ref <- factor(ifelse(test$high_value, 1, 0), levels=c(0,1))
cm <- confusionMatrix(pred_class, ref, positive="1")
cm
