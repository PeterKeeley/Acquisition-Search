# Acquisition Search

Private deal screener for a self-funded search in Idaho's Treasure Valley: a buy box, a weighted scorecard, SBA 7(a) debt math and a ranked pipeline.

## How it works

- `index.html` is the whole app. No build step.
- `data/deals.json` holds the weekly finds. A scheduled Claude task searches Treasure Valley listings every Monday morning and commits new ones here, with a financial read in each deal's notes.
- Your own scores, edits and new deals save to Supabase, keyed by the same id, so an edited or deleted weekly find stays that way when new weeks arrive.
- Until Supabase is set up, edits save in your browser only (the page says so at the top).

## Setup

### 1. Domain and hosting (Cloudflare)
1. In Cloudflare, buy your domain under **Domain Registration**.
2. Go to **Workers & Pages → Create → Pages → Connect to Git** and pick this repo.
3. Build settings: framework preset **None**, build command **blank**, output directory **/**. Save and deploy.
4. In the Pages project, open **Custom domains** and add `deals.yourdomain.com`.

### 2. Put a login in front of it (Cloudflare Access)
Deal details often fall under broker NDAs, so the site shouldn't be public.
1. Open **Zero Trust** (free plan is fine) → **Access → Applications → Add an application → Self-hosted**.
2. Application domain: `deals.yourdomain.com`. Also add the `*.pages.dev` address Cloudflare gave the project, so that one is locked too.
3. Add a policy: **Allow**, include **Emails** → your email address.
Now only you can open the site, after a one-time code to your email.

### 3. Database for your edits (Supabase)
1. Create a project at supabase.com.
2. **SQL Editor → New query**: paste `supabase.sql`, replace `YOUR_EMAIL` (two places), and run it.
3. **Authentication → Users → Add user → Send invitation** to your email. (Sign-ups are off; only invited users can sign in.)
4. **Authentication → URL Configuration**: set Site URL to `https://deals.yourdomain.com` and add it under Redirect URLs.
5. **Settings → API**: copy the Project URL and the **anon public** key into `config.js`. Never use the service_role key in this repo.
6. Commit `config.js`. Open the site, enter your email under "Sign in to edit", and click the link Supabase emails you.

## The weekly search

The Monday scheduled task appends to `data/deals.json` and never edits or removes existing entries. Weekly finds show a "Weekly find" tag until you score and save them. Figures come from the public listing and are unverified until you see tax returns.
