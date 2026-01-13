---
title: Page Rating System
description: Integrate thumbs up/down ratings with Firebase
icon: thumbs-up
order: 9
tags:
  - firebase
  - rating
  - feedback
author: Arcane Arts
date: 2025-01-13
---

The page rating system allows visitors to provide feedback on documentation pages with a simple thumbs up/down interface. Ratings are stored client-side and can be integrated with Firebase Firestore for persistence.

## Enabling Ratings

Enable the rating widget in your `SiteConfig`:

```dart
SiteConfig(
  name: 'My Docs',
  ratingEnabled: true,
  ratingPromptText: 'Was this page helpful?',
  ratingThankYouText: 'Thanks for your feedback!',
)
```

## How It Works

1. A "Was this page helpful?" prompt appears at the bottom of each page
2. Users click thumbs up or thumbs down
3. Their choice is saved to localStorage to prevent duplicate votes
4. A custom JavaScript event `kb-rating` is dispatched for Firebase integration
5. A thank you message replaces the prompt

## Firebase Integration

To persist ratings to Firebase Firestore, add the Firebase SDK and listen for rating events.

### 1. Add Firebase SDK

Add Firebase scripts to your site's `index.html` or load them dynamically:

```html
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
<script>
  firebase.initializeApp({
    apiKey: "your-api-key",
    authDomain: "your-project.firebaseapp.com",
    projectId: "your-project-id",
  });
</script>
```

### 2. Listen for Rating Events

Add a script to handle rating submissions:

```javascript
document.addEventListener('kb-rating', async function(e) {
  const pagePath = e.detail.path;
  const isHelpful = e.detail.helpful;

  // Convert path to valid Firestore document ID
  const docId = pagePath.replace(/\//g, '_');
  const field = isHelpful ? 'helpful' : 'notHelpful';

  try {
    await firebase.firestore()
      .collection('pageRatings')
      .doc(docId)
      .set({
        [field]: firebase.firestore.FieldValue.increment(1),
        lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
      }, { merge: true });

    console.log('Rating saved successfully');
  } catch (error) {
    console.error('Error saving rating:', error);
  }
});
```

### 3. Firestore Security Rules

Add security rules to allow anonymous writes but prevent abuse:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /pageRatings/{docId} {
      // Allow read for analytics
      allow read: if true;

      // Allow incrementing counters only
      allow write: if request.resource.data.diff(resource.data).affectedKeys()
        .hasOnly(['helpful', 'notHelpful', 'lastUpdated']);
    }
  }
}
```

## Firestore Schema

The recommended schema for rating documents:

```
pageRatings/
  _guide_installation/
    helpful: 42
    notHelpful: 3
    lastUpdated: Timestamp
  _features_code-blocks/
    helpful: 15
    notHelpful: 1
    lastUpdated: Timestamp
```

Document IDs are derived from page paths with slashes replaced by underscores:
- `/guide/installation` becomes `_guide_installation`
- `/features/code-blocks` becomes `_features_code-blocks`

## Local Storage Keys

The rating system uses localStorage to track which pages the user has rated:

| Key Pattern | Value | Purpose |
|-------------|-------|---------|
| `kb-rated-{path}` | `'helpful'` or `'not-helpful'` | Prevents duplicate votes |

## Custom Event Details

The `kb-rating` event includes these details:

```javascript
{
  detail: {
    path: '/guide/installation',  // Page URL path
    helpful: true                  // true = thumbs up, false = thumbs down
  }
}
```

## Customization

### Custom Prompt Text

```dart
SiteConfig(
  ratingEnabled: true,
  ratingPromptText: 'Did this help?',
  ratingThankYouText: 'We appreciate your feedback!',
)
```

### Styling

The rating widget uses these CSS classes for customization:

| Class | Element |
|-------|---------|
| `.kb-rating` | Main container |
| `.kb-rating-prompt` | Prompt section (before voting) |
| `.kb-rating-thanks` | Thank you section (after voting) |
| `.kb-rating-btn` | Rating buttons |

Example custom styles in `styles.css`:

```css
.kb-rating-btn:hover {
  border-color: hsl(var(--primary));
  background: hsl(var(--accent));
}

.kb-rating-thanks {
  color: hsl(var(--primary));
}
```

## Analytics Dashboard

To view rating analytics, query your Firestore collection:

```javascript
async function getRatingSummary() {
  const snapshot = await firebase.firestore()
    .collection('pageRatings')
    .orderBy('helpful', 'desc')
    .get();

  const ratings = [];
  snapshot.forEach(doc => {
    const data = doc.data();
    ratings.push({
      page: doc.id.replace(/_/g, '/'),
      helpful: data.helpful || 0,
      notHelpful: data.notHelpful || 0,
      ratio: (data.helpful || 0) / ((data.helpful || 0) + (data.notHelpful || 1))
    });
  });

  return ratings;
}
```

## Alternative Backends

While Firebase is the recommended backend, you can integrate with any service by listening for the `kb-rating` event:

### Supabase Example

```javascript
document.addEventListener('kb-rating', async function(e) {
  const { path, helpful } = e.detail;

  await supabase.rpc('increment_rating', {
    page_path: path,
    is_helpful: helpful
  });
});
```

### REST API Example

```javascript
document.addEventListener('kb-rating', async function(e) {
  await fetch('/api/ratings', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(e.detail)
  });
});
```

## Disabling on Specific Pages

To disable ratings on specific pages, use frontmatter:

```yaml
---
title: Privacy Policy
rating: false
---
```

> [!NOTE]
> Page-level rating disable is planned for a future release. Currently, ratings appear on all pages when enabled globally.
