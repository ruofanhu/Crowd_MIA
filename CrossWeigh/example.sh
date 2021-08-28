export TRAIN_FILE=data/train.txt
export DEV_FILE=data/dev.txt
export DATA_FOLDER_PREFIX=splitdata
export MODEL_FOLDER_PREFIX=model
export WEIGHED_MODEL_FOLDER_NAME=weighed
mkdir -p ${DATA_FOLDER_PREFIX}/${WEIGHED_MODEL_FOLDER_NAME}

# creating splits
for splits in $(seq 1 1 3); do
    SPLIT_FOLDER=${DATA_FOLDER_PREFIX}/split-${splits}
    python split.py --input_files ${TRAIN_FILE} ${DEV_FILE} \
                    --output_folder ${SPLIT_FOLDER} \
                    --schema iob \
                    --folds 10
done

# training each split/fold
for splits in $(seq 1 1 3); do
    for folds in $(seq 0 1 9); do
        FOLD_FOLDER=split-${splits}/fold-${folds}
        python flair_scripts/flair_ner.py --folder_name ${FOLD_FOLDER} \
                                          --data_folder_prefix ${DATA_FOLDER_PREFIX} \
                                          --model_folder_prefix ${MODEL_FOLDER_PREFIX}
    done
done

# collecting results and forming a weighted train set.
python collect.py --split_folders ${DATA_FOLDER_PREFIX}/split-*  \
                  --train_files $TRAIN_FILE $DEV_FILE \
                  --train_file_schema iob \
                  --output ${DATA_FOLDER_PREFIX}/${WEIGHED_MODEL_FOLDER_NAME}/train.bio

# train the final model
python flair_scripts/flair_ner.py --folder_name ${WEIGHED_MODEL_FOLDER_NAME} \
                                  --data_folder_prefix ${DATA_FOLDER_PREFIX} \
                                  --model_folder_prefix ${MODEL_FOLDER_PREFIX} \
                                  --include_weight


export MODEL_FOLDER_PREFIX=model
export MODEL_FOLDER_NAME=weighed_w
export TEST_FILE=test.txt
export LABEL_MAP=label_map.json
export DATA_FOLDER_NAME=data
MODEL_FOLDER_NAME=${MODEL_FOLDER_PREFIX}/${MODEL_FOLDER_NAME}
# Predict the final model on the test data with ground truth label
python flair_scripts/flair_eval.py  --test_file_name ${TEST_FILE} \
                                    --label_map_name ${LABEL_MAP} \
                                    --data_folder_path ${DATA_FOLDER_NAME} \
                                    --model_folder_path ${MODEL_FOLDER_NAME} \