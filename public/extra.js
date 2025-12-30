document.addEventListener('DOMContentLoaded', function() {
  for (let i = 0; i < 100; i++) {
    const s = document.createElement('div');
    s.className = 'sparkle';
    s.style.left = Math.random() * 100 + 'vw';
    s.style.animationDelay = Math.random() * 10 + 's';
    s.style.animationDuration = (8 + Math.random() * 6) + 's';
    document.body.appendChild(s);
  }
});