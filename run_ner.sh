# Optional wandb environment vars

export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libffi.so.7
export WANDB_PROJECT="pixel-experiments"

# Settings

export LANG="hipe2022"
#export LANG="conll_2003_en"

export DATA_DIR="data/${LANG}"
#export DATA_DIR="data/masakhane-ner/data/${LANG}"

export FALLBACK_FONTS_DIR="data/fonts"  # let's say this is where we downloaded the fonts to
export MODEL="Team-PIXEL/pixel-base" # also works with "bert-base-cased", "roberta-base", etc.
export SEQ_LEN=196
export BSZ=64
export GRAD_ACCUM=1
export LR=5e-5
export SEED=42
export NUM_STEPS=15000
  
export RUN_NAME="${LANG}-$(basename ${MODEL})-${SEQ_LEN}-${BSZ}-${GRAD_ACCUM}-${LR}-${NUM_STEPS}-${SEED}"

CUDA_VISIBLE_DEVICES=4 python run_ner.py \
  --model_name_or_path=${MODEL} \
  --remove_unused_columns=False \
  --data_dir=${DATA_DIR} \
  --do_train \
  --do_eval \
  --do_predict \
  --dropout_prob=0.1 \
  --max_seq_length=${SEQ_LEN} \
  --max_steps=${NUM_STEPS} \
  --num_train_epochs=10 \
  --early_stopping \
  --early_stopping_patience=5 \
  --per_device_train_batch_size=${BSZ} \
  --gradient_accumulation_steps=${GRAD_ACCUM} \
  --learning_rate=${LR} \
  --warmup_steps=100 \
  --run_name=${RUN_NAME} \
  --output_dir=${RUN_NAME} \
  --overwrite_output_dir \
  --overwrite_cache \
  --logging_strategy=steps \
  --logging_steps=100 \
  --evaluation_strategy=steps \
  --eval_steps=500 \
  --save_strategy=steps \
  --save_steps=500 \
  --save_total_limit=5 \
  --report_to=wandb \
  --log_predictions \
  --load_best_model_at_end=True \
  --metric_for_best_model="eval_f1" \
  --fp16 \
  --half_precision_backend=apex \
  --fallback_fonts_dir=${FALLBACK_FONTS_DIR} \
  --seed=${SEED}
