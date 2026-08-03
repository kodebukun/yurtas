function urlBase64ToUint8Array(base64String) {
  var padding = '='.repeat((4 - base64String.length % 4) % 4);
  var base64 = (base64String + padding).replace(/-/g, '+').replace(/_/g, '/');
  var rawData = window.atob(base64);
  var outputArray = new Uint8Array(rawData.length);
  for (var i = 0; i < rawData.length; ++i) {
    outputArray[i] = rawData.charCodeAt(i);
  }
  return outputArray;
}

function csrfToken() {
  var meta = document.querySelector('meta[name="csrf-token"]');
  return meta ? meta.getAttribute('content') : '';
}

function vapidPublicKey() {
  var meta = document.querySelector('meta[name="vapid-public-key"]');
  return meta ? meta.getAttribute('content') : null;
}

function updateSubscribeButton(subscribed) {
  var btn = document.getElementById('push-subscribe-btn');
  if (!btn) return;
  if (subscribed) {
    btn.textContent = 'プッシュ通知を無効にする';
    btn.dataset.subscribed = 'true';
  } else {
    btn.textContent = 'プッシュ通知を有効にする';
    btn.dataset.subscribed = 'false';
  }
}

function setupPushButton() {
  var btn = document.getElementById('push-subscribe-btn');
  if (!btn) return;
  if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
    btn.parentElement.style.display = 'none';
    return;
  }

  navigator.serviceWorker.ready.then(function(reg) {
    reg.pushManager.getSubscription().then(function(sub) {
      updateSubscribeButton(!!sub);
    });
  });

  btn.addEventListener('click', function() {
    if (btn.dataset.subscribed === 'true') {
      unsubscribePush();
    } else {
      subscribePush();
    }
  });
}

function subscribePush() {
  var publicKey = vapidPublicKey();
  if (!publicKey) return;

  Notification.requestPermission().then(function(permission) {
    if (permission !== 'granted') return;

    navigator.serviceWorker.ready.then(function(reg) {
      reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(publicKey)
      }).then(function(sub) {
        var json = sub.toJSON();
        fetch('/push_subscriptions', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken()
          },
          body: JSON.stringify({
            endpoint: json.endpoint,
            p256dh: json.keys.p256dh,
            auth: json.keys.auth
          })
        }).then(function() {
          updateSubscribeButton(true);
        });
      });
    });
  });
}

function unsubscribePush() {
  navigator.serviceWorker.ready.then(function(reg) {
    reg.pushManager.getSubscription().then(function(sub) {
      if (!sub) return;
      sub.unsubscribe().then(function() {
        fetch('/push_subscriptions/destroy', {
          method: 'DELETE',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken()
          },
          body: JSON.stringify({ endpoint: sub.endpoint })
        }).then(function() {
          updateSubscribeButton(false);
        });
      });
    });
  });
}

document.addEventListener('turbolinks:load', setupPushButton);
