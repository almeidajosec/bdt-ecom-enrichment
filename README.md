# Ecommerce Attribution Capture — GTM Web Tag Template

Captures GA4 ecommerce **list** and **promotion** attribution at `view_item_list`,
`select_item`, `view_promotion`, `select_promotion` — and persists it per
`item_id` to `localStorage` so it can be joined back onto `add_to_cart`,
`begin_checkout`, `add_shipping_info`, `add_payment_info`, `purchase` and
`refund` via the companion **Ecommerce Enriched Items** variable template.

## Why this exists

By default GA4 attribution fields (`item_list_id`, `item_list_name`,
`promotion_id`, `promotion_name`) are only present on list/promotion events,
not on downstream purchase funnel events. This breaks item-level
"product listing" and "promotion" reports and downstream destinations like
Meta CAPI, Google Ads, and BigQuery.

This tag solves that by recording attribution at the capture moment and
exposing it through a paired variable for enrichment.

## What it captures (per item)

| Field | Source |
|---|---|
| `item_list_id` | Item-level, with ecommerce-root fallback |
| `item_list_name` | Item-level, with ecommerce-root fallback |
| `promotion_id` | Item-level, with ecommerce-root fallback |
| `promotion_name` | Item-level, with ecommerce-root fallback |
| `page_location` | `getUrl()` at capture time (full URL) |
| `page_type` | Configurable data-layer path (e.g. `page.type`) |
| `captured_at` | Epoch ms — used for TTL enforcement |
| `source_event` | `view_item_list` / `select_item` / `view_promotion` / `select_promotion` |

## Storage contract (v1)

- **Key (default):** `bdt_ecom_attr_v1` — must match the key on the companion variable.
- **Mechanism:** `localStorage` (origin-scoped; does **not** cross subdomains — use first-party cookies separately if you need that).
- **Shape:**
  ```json
  {
    "v": 1,
    "items": {
      "<item_id>": {
        "item_list_id": "...",
        "item_list_name": "...",
        "promotion_id": "...",
        "promotion_name": "...",
        "page_location": "...",
        "page_type": "...",
        "captured_at": 1713774000000,
        "source_event": "select_item"
      }
    }
  }
  ```
- **TTL:** enforced at write-time. Default 30 minutes (matches GA4's session timeout).

## Fields

| Field | Type | Default |
|---|---|---|
| Capture events | Simple table | `view_item_list`, `select_item`, `view_promotion`, `select_promotion` |
| Items data layer path | Text | `ecommerce.items` |
| Ecommerce root path (event-level fallback) | Text | `ecommerce` |
| Capture `page_location` | Checkbox | ON |
| Capture `page_type` | Checkbox | OFF |
| `page_type` data layer path | Text | `page.type` (shown when page_type enabled) |
| localStorage key | Text | `bdt_ecom_attr_v1` |
| TTL (minutes) | Number | `30` |
| Attribution strategy | Radio | Last click, then last view (recommended) / Last touch / First touch |
| Debug mode | Checkbox | OFF |

### Attribution strategy

- **Last click, then last view (recommended):** `select_*` events always win over
  `view_*` events. Within the same kind, the newest wins. Best reflects user intent —
  a later scroll that re-triggers `view_item_list` won't destroy the attribution
  from the click the user made 10 seconds earlier.
- **Last touch:** newest capture always overwrites.
- **First touch:** first capture within the TTL window is preserved.

## Permissions

- `access_local_storage` — read + write, keys matching `bdt_ecom_attr_*`
- `read_data_layer` — `event`, `ecommerce`, `ecommerce.*`, `page`, `page.*`
- `get_url` — any component
- `logging` — debug environment only

## Trigger setup

Create a Custom Event trigger matching `view_item_list|select_item|view_promotion|select_promotion`
(regex) OR four separate Custom Event triggers. The tag self-gates based on the
`Capture events` field, so you can safely point it at an "All Custom Events"
trigger too.

## Installation

1. Install from the GTM Community Template Gallery (search for "Ecommerce
   Attribution Capture"), or import `template.tpl` manually.
2. Create a new Tag → type = *Ecommerce Attribution Capture*.
3. Leave defaults, attach to the trigger(s) above.
4. Install the companion **Ecommerce Enriched Items** variable (separate
   template) and use it as the `items` parameter on all downstream GA4 event tags
   from `add_to_cart` through `purchase`.
5. Verify in Preview Mode: `select_item` on a product → DevTools → Application →
   Local Storage should contain a `bdt_ecom_attr_v1` key. Then `add_to_cart`
   should surface the captured `item_list_id` / `item_list_name` /
   `page_location` / `page_type` on the item in the GA4 DebugView hit.

## Known limitations

- Safari ITP caps 1st-party script-written `localStorage` to 7 days. Attribution
  older than the TTL you set (<7 days anyway) is unaffected.
- `localStorage` is scoped to a single origin. If your funnel spans multiple
  subdomains (e.g. `shop.example.com` → `checkout.example.com`), a future v1.1
  will add first-party cookie support. Until then, pin the flow to one origin.
- SPAs must push fresh `ecommerce.items` payloads on every route change — this
  tag reads from the data layer as configured.

## License

Apache 2.0. See LICENSE.

## Issues / contributions

File issues on this GitHub repository. Issues must remain enabled per Gallery
policy.
