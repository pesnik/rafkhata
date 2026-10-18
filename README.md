# রাফখাতা (Rafkhata)

**Live: https://rafkhata.pesnik.dev/**

রাফখাতা is a simple Bengali poetry notebook. It uses Avro phonetic input and keeps
drafts in your browser.

Built on [AvroPad](https://github.com/omicronlab/avro-pad) by OmicronLab.

## Features

- Avro phonetic typing with dictionary suggestions.
- Drafts stored in `localStorage`; nothing is sent to a server.
- Prose, verse, and quatrain writing formats.
- Adjustable font size and line height.
- Light and dark themes with low-contrast colours for long writing sessions.
- Bundled Noto Sans Bengali (SIL OFL). The optional Li Subha font is local-only
  and is not distributed.

## Development

Gulp 3 requires Node 8.

```bash
npm install
npx gulp watch   # http://localhost:8080/
```

## Build and deploy

```bash
npx gulp build
./scripts/deploy-pages.sh "your message"
```

The deploy script builds the site, removes the local Li Subha font files, pushes
the result to `gh-pages`, and keeps the Cloudflare Workers configuration in place.
The site is served from both GitHub Pages and https://rafkhata.pesnik.dev/.

## Credits

AvroPad was created by [Sarim Khan](https://github.com/sarim) and is maintained by
OmicronLab. Contributors:

- Sarim Khan
- Rifat Nabi
- Mehdi Hasan
- Tanbin Islam Siyam

## License

Rafkhata is licensed under the Mozilla Public License 1.1 ("MPL"). See
[MPL-1.1.txt](MPL-1.1.txt). Noto Sans Bengali is licensed under the SIL Open Font
License; see [src/fonts-noto/OFL.txt](src/fonts-noto/OFL.txt).
