# Previews

Static hosting for client-facing website mockups, served by GitHub Pages.
One folder per client. Each folder is served at its own URL, and clients only
ever receive the link to their own folder.

```
previews/
  index.html            neutral root — deliberately does NOT list clients
  robots.txt            Disallow: / — keeps previews out of search results
  update.ps1            injects noindex, commits, pushes, waits for deploy
  .nojekyll             stops GitHub from running Jekyll over the files
  <client-slug>/
    index.html          chooser page, if the client has several versions
    *.html              self-contained exports
```

Preview URLs are deliberately not written down in this file. This repo is public
and Google crawls GitHub, so a URL listed here becomes a discoverable link to a
page that is supposed to stay unlisted. Keep the addresses in your email client.

## Adding a new client

1. `mkdir <client-slug>` — lowercase, hyphenated. It becomes the URL.
2. Drop the exported HTML file(s) in.
3. Run `.\update.ps1`.
4. Send them the folder URL.

If a client has only one version to review, name the file `index.html` and the
folder URL serves it directly — no chooser page needed.

If a client has several versions, add a chooser `index.html` that links to them,
and keep the exported filenames stable — the chooser links to them by exact name.

## Updating an existing preview

Overwrite the HTML file with the fresh export and run `.\update.ps1`. The URL
never changes, so a link you already emailed keeps working and shows the new
version.

Don't hand-edit an exported file for anything other than what `update.ps1` does
automatically. Every manual change is silently lost on the next export — set
titles, colors and content in the design tool instead.

## Keeping previews out of search results

Three layers, because GitHub Pages gives no control over response headers
(`X-Robots-Tag` is unavailable, and `_headers` files are a Netlify/Cloudflare
feature that Pages ignores):

- `robots.txt` disallows all crawling of the whole site.
- Every HTML page carries a `noindex, nofollow, noarchive, nosnippet` tag.
  `update.ps1` re-injects it after every export, since exports don't include it.
- No preview URL is written down anywhere public, including this README.

That last one matters most. A page blocked by `robots.txt` can still be indexed
as a bare URL if a crawler finds a link to it somewhere else — and because
`robots.txt` stops the crawler from fetching the page at all, it never reads the
`noindex` tag that would have removed it. Not publishing the links is what keeps
the other two layers from being tested.

None of this is access control. There is no password on a GitHub Pages site, and
anyone with a URL can open it.

## Things worth knowing

- **This repo is public.** Anyone can read every preview in it, and browse the
  repo on GitHub. Don't put anything here you wouldn't show all of your clients —
  no pricing, no notes, no credentials. Project notes belong in the private
  per-client repo.
- Exports render entirely client-side, so a preview shows nothing until
  JavaScript runs. Fine for review; not how a production site should ship.
- Exports may reference remote images (Unsplash and similar) by URL rather than
  embedding them. Those need network access to appear, and they break if the
  remote host does. Self-host the images before a site goes live.
