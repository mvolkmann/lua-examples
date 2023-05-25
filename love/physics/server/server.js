const express = require('express');

const app = express();

app.use(express.static(
  '../web',
  {
    setHeaders: res => {
      res.set('Cross-Origin-Opener-Policy', 'same-origin');
      res.set('Cross-Origin-Embedder-Policy', 'require-corp');
    }
  }
));

const PORT = 1919;
app.listen(PORT, () => console.log('ready'));
