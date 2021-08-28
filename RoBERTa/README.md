# RoBERTa
Codes for training RoBERTa on Crowd-MIA dataset.
Below and default parameters in each code files are parameter settings that we used to train models in paper's experiment section.

## Usage
In the example scripts below, all data files were supposed to store under ./crowd directory. WEAK_SOURCE is the name of weak label data subdirectory, 
if WEAK_SOURCE is left empty, the code will use the ground truth label by default.
Please download all required data file from our dataset URL and store them in the corresponding directory.
We will release the data to public upon acceptation.

### Train TRC model
```linux
WEAK_SOURCE=
python main_sequence.py \
   --seed 2021 \
   --bert_model roberta-base \
   --model_type bertweet-seq \
   --data ./crowd-mia \
   --train_file ${WEAK_SOURCE}train.p \
   --val_file ${WEAK_SOURCE}dev.p \
   --test_file test.p \
   --assign_weight \
   --learning_rate 1e-5 \
   --n_epochs 20 \
   --log_dir test \
```

assign_weight is to determine if assign weights to cross entropy loss, weight is calculated by the proportion of tweet classes in training set

n_epochs is number of epochs to training model

### Train EMD/ERC model
```linux
WEAK_SOURCE=
python main_token.py \
   --seed 2021 \
   --bert_model roberta-base \
   --task_type [entity_detection|entity_relevance_classification] \
   --model_type bertweet-token-crf \
   --data ./crowd-mia \
   --train_file ${WEAK_SOURCE}train.p \
   --val_file ${WEAK_SOURCE}dev.p \
   --test_file test.p \
   --label_map [label_map.json|re_label_map.json] \
   --assign_weight \
   --n_epochs 20 \
   --learning_rate 1e-5 \
   --log_dir test \
```

label_map.json is the label_map for EMD task, re_label_map.json is for ERC task.

assign_weight is to determine if assign weight to cross entropy loss, weight is calculated by the proportion of entities' frequeny in training set

### Train TRC + EMD/ERC model
```linux
WEAK_SOURCE=
python main_multi.py \
   --seed 2021 \
   --bert_model roberta-base \
   --model_type bertweet-multi-crf \
   --task_type [entity_detection|entity_relevance_classification] \
   --data ./crowd-mia \
   --train_file ${WEAK_SOURCE}train.p \
   --val_file ${WEAK_SOURCE}dev.p \
   --test_file test.p \
   --label_map [label_map.json|re_label_map.json] \
   --assign_token_weight \
   --assign_seq_weight \
   --n_epochs 20 \
   --learning_rate 1e-5 \
   --token_lambda 10 \
   --log_dir test \
```

token_lambda is the lambda value assiging to word level task loss, we used 10 in our experiment.

assign_token_weight is to determine if assign weight to word level task cross entropy loss, weight is calculated by the proportion of entities' frequeny in training set

assign_seq_weight is to determine if assign weights to TRC task cross entropy loss, weight is calculated by the proportion of tweet classes in training set

### Train EMD+ERC model
```linux
WEAK_SOURCE=
python main_two_token.py \
   --seed 2021 \
   --bert_model roberta-base \
   --task_type 'entity_detection & entity_relevance_classification' \
   --model_type bertweet-two-token-crf \
   --data ./crowd-mia \
   --train_file ${WEAK_SOURCE}train.p \
   --val_file ${WEAK_SOURCE}dev.p \
   --test_file test.p \
   --label_map label_map.json \
   --se_label_map re_label_map.json \
   --assign_token_weight \
   --assign_se_weight \
   --n_epochs 20 \
   --learning_rate 1e-5 \
   --log_dir test \
```

assign_token_weight is to determine if assign weight to EMD task cross entropy loss, weight is calculated by the proportion of entities' frequeny in training set

assign_se_weight is to determine if assign weights to ERC task cross entropy loss, weight is calculated by the proportion of entities' frequeny in training set
