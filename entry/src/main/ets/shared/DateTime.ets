function pad(value: number): string {
  return value < 10 ? `0${value}` : value.toString();
}

export function formatLocalMinute(date: Date): string {
  return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ` +
    `${pad(date.getHours())}:${pad(date.getMinutes())}`;
}

