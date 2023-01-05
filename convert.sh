# !/bin/bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
date=$(date +"%Y-%m-%d_%H-%M-%S")

rd_logs="/tmp/convert_dupe_logs/logs"
test_rd_logs="/tmp/convert_dupe_logs/TEST_logs"
indicator="/convert/logs"
mkdir -p $rd_logs
mkdir -p $test_rd_logs
mkdir -p $indicator

echo "Script started...$date" >>$indicator/status.txt

#Initial Cleanup
if [[ $action == "True" ]]; then
  echo "Initial Cleanup...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
        [ -f "${pathname%.mkv}.mp4" ] && echo rm "$pathname" >> '$rd_logs'/dupes_removed_'$date'.txt && rm "$pathname"
    done' sh {} +
  echo "Initial Cleanup...Completed" >>$indicator/status.txt
else
  echo "TEST - Initial Cleanup...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
        [ -f "${pathname%.mkv}.mp4" ] && echo rm "$pathname" >> '$test_rd_logs'/TEST_dupes_removed_'$date'.txt
    done' sh {} +
  echo "TEST - Initial Cleanup...Completed" >>$indicator/status.txt
fi

#Convert MKV to MP4
if [[ $action == "True" ]]; then
  echo "Convert MKV to MP4...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
      echo "$pathname" >> '$rd_logs'/media_coverted_'$date'.txt && ffmpeg -y -i "$pathname" -c copy "${pathname%.*}.mp4"
    done' sh {} +
  echo "Convert MKV to MP4...Completed" >>$indicator/status.txt
else
  echo "TEST - Convert MKV to MP4...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
      echo "$pathname" >> '$test_rd_logs'/TEST_media_coverted_'$date'.txt
    done' sh {} +
  echo "TEST - Convert MKV to MP4...Completed" >>$indicator/status.txt
fi

#Follow-up Clean up
if [[ $action == "True" ]]; then
  echo "Follow-up Cleanup...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
        [ -f "${pathname%.mkv}.mp4" ] && echo rm "$pathname" >> '$rd_logs'/dupes_removed_'$date'.txt && rm "$pathname"
    done' sh {} +
  echo "Follow-up Cleanup...Completed" >>$indicator/status.txt
else
  echo "TEST - Follow-up Cleanup...Started" >>$indicator/status.txt
  find $media_folder -type f -name '*.mkv' -exec sh -c '
    for pathname do
        [ -f "${pathname%.mkv}.mp4" ] && echo rm "$pathname" >> '$test_rd_logs'/TEST_dupes_removed_'$date'.txt
    done' sh {} +
  echo "TEST - Follow-up Cleanup...Completed" >>$indicator/status.txt
fi
