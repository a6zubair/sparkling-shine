# Sparkling Shine

A responsive, static website for Zubair Khalil’s residential and home painting company. Plain HTML, CSS, and locally stored SVG illustrations; no JavaScript, dependencies, build step, analytics, or third-party assets.

## Contact information

- Owner: Zubair Khalil
- Phone: 416-566-8156
- Email: zubairfunds@gmail.com
- Services: Residential painting and home painting
- Quotations: By email

The quotation buttons open the visitor’s email application. The contact section includes a prefilled email with project details to complete. There is no backend form or automatic email sending.

## Preview

Open `index.html` in a browser. All assets use relative paths, so no server is required.

For an optional local server, run this from the site directory:

```sh
python3 -m http.server 8000
```

Then visit <http://localhost:8000>.

## Publish to GitHub Pages

Intended repository: `a6zubair/sparkling-shine`.

Expected URL **after a successful deployment**: <https://a6zubair.github.io/sparkling-shine/>.

The site has not been published from the authoring environment because its terminal cannot reach GitHub and browser access is unavailable. The connected GitHub plugin can read repositories and update files, but does not expose repository creation or Pages settings.

On a computer with Git, [GitHub CLI](https://cli.github.com/), and network access, sign in as `a6zubair` if needed:

```sh
gh auth login
```

Then run from this directory:

```sh
bash publish.sh
```

The script checks the account, creates a public repository containing only the listed site files, pushes `main`, and enables Pages from `main` at `/ (root)`. It waits up to four minutes for the Pages build and reports success, failure, or pending status. It uses a GitHub noreply address for commits and does not change global Git settings. It refuses to overwrite an existing unrelated repository.

After publishing, edits can be deployed by running `bash publish.sh` again from the same checkout.

### Manual alternative

1. Create a public GitHub repository named `sparkling-shine` under `a6zubair`.
2. Add the files in this directory to its `main` branch, keeping `index.html` at the repository root and preserving the `assets` directory and `.nojekyll` file.
3. Open **Settings → Pages**.
4. Select **Deploy from a branch**, then **main** and **/ (root)**. Save.
5. Wait for the Pages deployment to succeed and open the website link shown by GitHub.

Reference: [GitHub’s Pages setup guide](https://docs.github.com/en/pages/getting-started-with-github-pages/creating-a-github-pages-site).

## Editing

- `index.html`: page copy, services, navigation, and contact links.
- `styles.css`: layout, colours, typography, and responsive styles.
- `assets/painted-room.svg`: original decorative room illustration, not a photograph of completed work.
- `assets/favicon.svg`: brand icon.
- `404.html`: missing-page message. Its home link assumes the `/sparkling-shine/` GitHub Pages project path; update it if the deployment path changes.
- `.nojekyll`: serves the site as static files without Jekyll processing.

No service area, prices, reviews, certifications, or guarantees are claimed. Add those details only when confirmed by the business owner.

## Verification

The authoring checks cover HTML parsing, local asset and anchor references, contact destinations, SVG syntax, CSS parsing, and shell syntax. Browser rendering and actual GitHub Pages deployment remain unverified until browser/network access is available.
