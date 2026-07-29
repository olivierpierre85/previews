# Previews

Static hosting for client-facing website mockups, served by GitHub Pages at
`https://olivierpierre85.github.io/previews/`.

One folder per client. Each folder is served at its own URL, and clients only ever
receive the link to their own folder.

```
previews/
  index.html            neutral root — deliberately does NOT list clients
  robots.txt            Disallow: / — keeps previews out of search results
  .nojekyll             stops GitHub from running Jekyll over the files
  elevate-electric/
    index.html          theme chooser
    green.html          self-contained export
    black.html          self-contained export
```

## Adding a new client

1. `mkdir <client-slug>` — lowercase, hyphenated. It becomes the URL.
2. Drop the exported HTML file(s) in. They are self-contained: everything (fonts,
   images, React) is embedded, so no build step and no external requests.
3. Commit and push. Pages redeploys in about a minute.
4. Send them `https://olivierpierre85.github.io/previews/<client-slug>/`.

If a client has only one version to review, name the file `index.html` and the folder
URL serves it directly — no chooser page needed.

## Updating an existing preview

Overwrite the HTML file with the fresh export, commit, push. The URL never changes,
so a link you already emailed keeps working and shows the new version.

Don't hand-edit the exported HTML. Any change made here is lost on the next export —
set titles, colors and content in the design tool instead.

## Things worth knowing

- **This repo is public.** Anyone with the URL can read every preview in it, and the
  repo itself is browsable on GitHub. Don't put anything here you wouldn't show all
  of your clients — no pricing, no notes, no credentials. Project notes belong in the
  private per-client repo.
- `robots.txt` and the `noindex` tags keep previews out of search results, but they
  are not access control. There is no password on a GitHub Pages site.
- Exports run entirely client-side, so a preview renders nothing until JavaScript
  loads. That is fine for review, but it is not how the production site should ship.
