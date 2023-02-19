if [[ -f proc.pid ]]; then
    pkill -F proc.pid && rm proc.pid && echo 'Stopped' || echo 'Failed to stop' && exit 1
fi

echo 'No PID file. Please stop the program manually.' && exit 1
