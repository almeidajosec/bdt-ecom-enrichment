___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Ecommerce Attribution Capture",
  "brand": {
    "id": "brand_dummy",
    "displayName": "Better Data Today"
  },
  "description": "Captures GA4 ecommerce list & promotion attribution (item_list_id, item_list_name, promotion_id, promotion_name, page_location, page_type) per item_id to localStorage, so it can be joined back onto add_to_cart/begin_checkout/purchase items.",
  "containerContexts": [
    "WEB"
  ],
  "categories": [
    "ATTRIBUTION",
    "ANALYTICS",
    "UTILITY"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "LABEL",
    "name": "introLabel",
    "displayName": "Fires on GA4 ecommerce list and promotion events (view_item_list, select_item, view_promotion, select_promotion) and stores per-item attribution in localStorage. Pair with the \"Ecommerce Enriched Items\" variable to join this attribution back onto add_to_cart, begin_checkout and purchase."
  },
  {
    "type": "GROUP",
    "name": "captureGroup",
    "displayName": "Capture configuration",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SIMPLE_TABLE",
        "name": "captureEvents",
        "displayName": "Capture events",
        "help": "Only fires capture logic when the current event name matches one of the rows below. Trigger this tag on any event that might match — the tag will self-gate.",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Event name",
            "name": "eventName",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              }
            ]
          }
        ],
        "newRowButtonText": "Add event",
        "newRowTemplate": {
          "eventName": ""
        },
        "defaultValue": [
          {
            "eventName": "view_item_list"
          },
          {
            "eventName": "select_item"
          },
          {
            "eventName": "view_promotion"
          },
          {
            "eventName": "select_promotion"
          }
        ]
      },
      {
        "type": "TEXT",
        "name": "itemsDataLayerPath",
        "displayName": "Items data layer path",
        "simpleValueType": true,
        "defaultValue": "ecommerce.items",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          }
        ],
        "help": "Dot-path to the items array on the data layer. GA4 convention is ecommerce.items."
      },
      {
        "type": "TEXT",
        "name": "ecommerceRootPath",
        "displayName": "Ecommerce root path (for event-level fallbacks)",
        "simpleValueType": true,
        "defaultValue": "ecommerce",
        "help": "Some GA4 implementations put item_list_id / item_list_name / promotion_id / promotion_name once at the ecommerce root instead of on every item. This is read as a fallback when the item itself has no value."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "pageGroup",
    "displayName": "Page context",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "includePageLocation",
        "checkboxText": "Capture page_location (full current URL) of the attribution event",
        "simpleValueType": true,
        "defaultValue": true
      },
      {
        "type": "CHECKBOX",
        "name": "includePageType",
        "checkboxText": "Capture page_type",
        "simpleValueType": true,
        "defaultValue": false
      },
      {
        "type": "TEXT",
        "name": "pageTypeSource",
        "displayName": "page_type data layer path",
        "simpleValueType": true,
        "defaultValue": "page.type",
        "help": "Dot-path to a data layer value carrying the page type classification (e.g. category, brand, pdp, home, search, promo).",
        "enablingConditions": [
          {
            "paramName": "includePageType",
            "paramValue": true,
            "type": "EQUALS"
          }
        ]
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "storageGroup",
    "displayName": "Storage",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "TEXT",
        "name": "storageKey",
        "displayName": "localStorage key",
        "simpleValueType": true,
        "defaultValue": "bdt_ecom_attr_v1",
        "valueValidators": [
          {
            "type": "NON_EMPTY"
          },
          {
            "type": "REGEX",
            "args": [
              "^bdt_ecom_attr_[A-Za-z0-9_]+$"
            ],
            "errorMessage": "Key must start with bdt_ecom_attr_ followed by alphanumerics / underscores."
          }
        ],
        "help": "Must match the key configured on the companion Enriched Items variable."
      },
      {
        "type": "TEXT",
        "name": "ttlMinutes",
        "displayName": "Attribution TTL (minutes)",
        "simpleValueType": true,
        "defaultValue": 30,
        "valueValidators": [
          {
            "type": "POSITIVE_NUMBER"
          },
          {
            "type": "NON_EMPTY"
          }
        ],
        "valueHint": "30",
        "help": "Entries older than this are dropped on the next write. Default 30 matches GA4's session timeout."
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "strategyGroup",
    "displayName": "Attribution strategy",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "RADIO",
        "name": "attributionStrategy",
        "displayName": "When a product is captured more than once within the TTL window",
        "radioItems": [
          {
            "value": "last_click_then_view",
            "displayValue": "Last click, then last view (recommended): select_* wins over view_*; within the same kind, the newest wins"
          },
          {
            "value": "last_touch",
            "displayValue": "Last touch: newest capture always overwrites"
          },
          {
            "value": "first_touch",
            "displayValue": "First touch: first capture never overwrites"
          }
        ],
        "simpleValueType": true,
        "defaultValue": "last_click_then_view"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "debugGroup",
    "displayName": "Debugging",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "CHECKBOX",
        "name": "debugMode",
        "checkboxText": "Log to console in Preview / debug environments",
        "simpleValueType": true,
        "defaultValue": false
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const copyFromDataLayer = require('copyFromDataLayer');
const localStorage = require('localStorage');
const getUrl = require('getUrl');
const getTimestampMillis = require('getTimestampMillis');
const JSON = require('JSON');
const logToConsole = require('logToConsole');
const queryPermission = require('queryPermission');
const makeInteger = require('makeInteger');
const getType = require('getType');

const DEBUG = data.debugMode === true;

const STORAGE_KEY = data.storageKey || 'bdt_ecom_attr_v1';
const TTL_MS = (makeInteger(data.ttlMinutes) || 30) * 60 * 1000;
const STRATEGY = data.attributionStrategy || 'last_click_then_view';

const captureEvents = (data.captureEvents || []).map(function(row) {
  return row.eventName;
});

const currentEvent = copyFromDataLayer('event');
if (captureEvents.indexOf(currentEvent) === -1) {
  if (DEBUG) logToConsole('[BDT Capture] No-op for event:', currentEvent);
  return data.gtmOnSuccess();
}

if (!queryPermission('access_local_storage', STORAGE_KEY)) {
  if (DEBUG) logToConsole('[BDT Capture] Missing localStorage permission for key:', STORAGE_KEY);
  return data.gtmOnFailure();
}

const itemsPath = data.itemsDataLayerPath || 'ecommerce.items';
const ecomPath = data.ecommerceRootPath || 'ecommerce';
const items = copyFromDataLayer(itemsPath) || [];
const ecom = copyFromDataLayer(ecomPath) || {};

if (getType(items) !== 'array' || items.length === 0) {
  if (DEBUG) logToConsole('[BDT Capture] No items for event:', currentEvent);
  return data.gtmOnSuccess();
}

let pageLocation;
if (data.includePageLocation && queryPermission('get_url')) {
  pageLocation = getUrl();
}

let pageType;
if (data.includePageType && data.pageTypeSource) {
  pageType = copyFromDataLayer(data.pageTypeSource);
}

const now = getTimestampMillis();

let blob;
const raw = localStorage.getItem(STORAGE_KEY);
if (raw) {
  blob = JSON.parse(raw);
}
if (!blob || getType(blob) !== 'object' || !blob.items) {
  blob = { v: 1, items: {} };
}

// Rebuild items map, dropping expired entries.
// The GTM sandbox does not support the `delete` operator, so we filter into a fresh object.
const freshItems = {};
const existingIds = Object.keys(blob.items);
for (let i = 0; i < existingIds.length; i++) {
  const key = existingIds[i];
  const entry = blob.items[key];
  if (entry && entry.captured_at && now - entry.captured_at <= TTL_MS) {
    freshItems[key] = entry;
  }
}
blob.items = freshItems;

const fallbackListId = ecom.item_list_id;
const fallbackListName = ecom.item_list_name;
const fallbackPromoId = ecom.promotion_id;
const fallbackPromoName = ecom.promotion_name;

const isClickEvent = function(evName) {
  return evName === 'select_item' || evName === 'select_promotion';
};

const resolveAttribution = function(existing, candidate, strategy) {
  if (!existing) return candidate;
  if (strategy === 'first_touch') return existing;
  if (strategy === 'last_touch') return candidate;
  const candIsClick = isClickEvent(candidate.source_event);
  const existIsClick = isClickEvent(existing.source_event);
  if (existIsClick && !candIsClick) return existing;
  return candidate;
};

for (let j = 0; j < items.length; j++) {
  const it = items[j] || {};
  const id = it.item_id || it.item_name;
  if (!id) continue;
  const candidate = {
    item_list_id: it.item_list_id || fallbackListId,
    item_list_name: it.item_list_name || fallbackListName,
    promotion_id: it.promotion_id || fallbackPromoId,
    promotion_name: it.promotion_name || fallbackPromoName,
    page_location: pageLocation,
    page_type: pageType,
    captured_at: now,
    source_event: currentEvent
  };
  blob.items[id] = resolveAttribution(blob.items[id], candidate, STRATEGY);
}

localStorage.setItem(STORAGE_KEY, JSON.stringify(blob));
if (DEBUG) logToConsole('[BDT Capture] Stored attribution. event:', currentEvent, 'items:', items.length);

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "bdt_ecom_attr_*"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "read_data_layer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keyPatterns",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "event"
              },
              {
                "type": 1,
                "string": "ecommerce"
              },
              {
                "type": 1,
                "string": "ecommerce.*"
              },
              {
                "type": 1,
                "string": "page"
              },
              {
                "type": 1,
                "string": "page.*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: No-op when event not in capture list
  code: |-
    const mockData = {
      captureEvents: [{eventName: 'select_item'}],
      itemsDataLayerPath: 'ecommerce.items',
      ecommerceRootPath: 'ecommerce',
      storageKey: 'bdt_ecom_attr_v1',
      ttlMinutes: 30,
      attributionStrategy: 'last_click_then_view'
    };
    mock('copyFromDataLayer', (key) => {
      if (key === 'event') return 'add_to_cart';
      return undefined;
    });
    runCode(mockData);
    assertApi('localStorage.setItem').wasNotCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: Writes attribution blob on select_item
  code: |-
    const mockData = {
      captureEvents: [{eventName: 'select_item'}],
      itemsDataLayerPath: 'ecommerce.items',
      ecommerceRootPath: 'ecommerce',
      storageKey: 'bdt_ecom_attr_v1',
      ttlMinutes: 30,
      attributionStrategy: 'last_click_then_view',
      includePageLocation: true
    };
    mock('copyFromDataLayer', (key) => {
      if (key === 'event') return 'select_item';
      if (key === 'ecommerce.items') return [{
        item_id: 'SKU1',
        item_name: 'Blue Shirt',
        item_list_id: 'home_recs',
        item_list_name: 'Home Recommendations'
      }];
      if (key === 'ecommerce') return {};
      return undefined;
    });
    mock('localStorage', {
      getItem: () => null,
      setItem: () => undefined,
      removeItem: () => undefined
    });
    mock('getUrl', () => 'https://shop.example.com/');
    mock('getTimestampMillis', () => 1000);
    runCode(mockData);
    assertApi('localStorage.setItem').wasCalled();
    assertApi('gtmOnSuccess').wasCalled();

- name: last_click_then_view preserves select_item over later view_item_list
  code: |-
    const existing = JSON.stringify({
      v: 1,
      items: {
        SKU1: {
          item_list_id: 'home_recs',
          item_list_name: 'Home Recommendations',
          source_event: 'select_item',
          captured_at: 500
        }
      }
    });
    const mockData = {
      captureEvents: [{eventName: 'view_item_list'}],
      itemsDataLayerPath: 'ecommerce.items',
      ecommerceRootPath: 'ecommerce',
      storageKey: 'bdt_ecom_attr_v1',
      ttlMinutes: 30,
      attributionStrategy: 'last_click_then_view'
    };
    let written;
    mock('copyFromDataLayer', (key) => {
      if (key === 'event') return 'view_item_list';
      if (key === 'ecommerce.items') return [{item_id: 'SKU1', item_list_id: 'category_shirts'}];
      if (key === 'ecommerce') return {};
      return undefined;
    });
    mock('localStorage', {
      getItem: () => existing,
      setItem: (k, v) => { written = v; },
      removeItem: () => undefined
    });
    mock('getTimestampMillis', () => 1000);
    runCode(mockData);
    require('assertThat')(written).isNotEqualTo(undefined);
    const parsed = require('JSON').parse(written);
    require('assertThat')(parsed.items.SKU1.source_event).isEqualTo('select_item');
    require('assertThat')(parsed.items.SKU1.item_list_id).isEqualTo('home_recs');

- name: Expired entries pruned on write
  code: |-
    const existing = require('JSON').stringify({
      v: 1,
      items: {
        OLD: { source_event: 'select_item', captured_at: 1, item_list_id: 'stale' }
      }
    });
    const mockData = {
      captureEvents: [{eventName: 'select_item'}],
      itemsDataLayerPath: 'ecommerce.items',
      ecommerceRootPath: 'ecommerce',
      storageKey: 'bdt_ecom_attr_v1',
      ttlMinutes: 1,
      attributionStrategy: 'last_touch'
    };
    let written;
    mock('copyFromDataLayer', (key) => {
      if (key === 'event') return 'select_item';
      if (key === 'ecommerce.items') return [{item_id: 'NEW', item_list_id: 'fresh'}];
      if (key === 'ecommerce') return {};
      return undefined;
    });
    mock('localStorage', {
      getItem: () => existing,
      setItem: (k, v) => { written = v; }
    });
    mock('getTimestampMillis', () => 60 * 60 * 1000);
    runCode(mockData);
    const parsed = require('JSON').parse(written);
    require('assertThat')(parsed.items.OLD).isEqualTo(undefined);
    require('assertThat')(parsed.items.NEW).isNotEqualTo(undefined);


___NOTES___

Created by Better Data Today (betterdatatoday.com) for white-label agency delivery.

Pair this Tag with the companion "Ecommerce Enriched Items" Variable template to make captured attribution flow into add_to_cart / begin_checkout / purchase items.

Storage contract (v1):
- Key (default): bdt_ecom_attr_v1
- Mechanism: localStorage (origin-scoped)
- Shape: { v: 1, items: { "<item_id>": { item_list_id, item_list_name, promotion_id, promotion_name, page_location, page_type, captured_at, source_event } } }
- TTL enforced at write-time (default 30 min).
