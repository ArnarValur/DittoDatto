// server/utils/slugify.ts
export const nordicSlugify = (text: string): string => {
  const map: Record<string, string> = {
    æ: 'ae', ø: 'o', å: 'a',
    ö: 'o', ä: 'a', ð: 'd', þ: 'th',
    ü: 'u', é: 'e', è: 'e'
  }

  return text
    .toString()
    .toLowerCase()
    .split('')
    .map(char => map[char] || char) // Replace Nordic chars
    .join('')
    .normalize('NFD').replace(/[\u0300-\u036f]/g, '') // Remove remaining accents
    .replace(/\s+/g, '-') // Spaces to dashes
    .replace(/[^\w\-]+/g, '') // Remove all non-word chars
    .replace(/\-\-+/g, '-') // Replace multiple dashes with single
    .replace(/^-+/, '') // Trim start
    .replace(/-+$/, '') // Trim end
}
