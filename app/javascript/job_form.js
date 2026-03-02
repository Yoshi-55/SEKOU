// 案件投稿フォームの通知先メンバー選択機能
(function() {
  function initializeNotificationSettings() {
    const groupSelect = document.querySelector('[data-groups]');
    const notificationSettings = document.getElementById('notification-settings');
    const memberCheckboxesContainer = document.getElementById('member-checkboxes');
    const notifyAllCheckbox = document.getElementById('notify_all_checkbox');

    if (!groupSelect) return;

    const groupsData = JSON.parse(groupSelect.dataset.groups || '[]');

    // 既存の notified_member_ids を取得（編集時用）
    const existingNotifiedMemberIds = groupSelect.dataset.notifiedMemberIds
      ? JSON.parse(groupSelect.dataset.notifiedMemberIds)
      : [];

    function updateNotificationSettings() {
      const selectedGroupId = parseInt(groupSelect.value);

      if (!selectedGroupId) {
        notificationSettings.style.display = 'none';
        return;
      }

      const selectedGroup = groupsData.find(g => g.id === selectedGroupId);
      if (!selectedGroup) {
        notificationSettings.style.display = 'none';
        return;
      }

      // メンバーチェックボックスを生成
      memberCheckboxesContainer.innerHTML = '';
      selectedGroup.members.forEach(member => {
        const label = document.createElement('label');
        label.className = 'flex items-center gap-2 cursor-pointer';

        const checkbox = document.createElement('input');
        checkbox.type = 'checkbox';
        checkbox.name = 'job[notified_member_ids][]';
        checkbox.value = member.id;
        checkbox.className = 'w-5 h-5 rounded border-gray-300 member-checkbox';
        checkbox.disabled = notifyAllCheckbox.checked;

        // 既存の選択状態を復元（編集時）
        // existingNotifiedMemberIds は文字列配列、member.id は整数なので、両方を文字列に変換して比較
        const memberIdStr = String(member.id);
        const existingIdsStr = existingNotifiedMemberIds.map(id => String(id));
        const isSelected = existingIdsStr.includes(memberIdStr);
        if (isSelected) {
          checkbox.checked = true;
        }

        const span = document.createElement('span');
        span.className = 'text-base';
        span.textContent = member.name;

        label.appendChild(checkbox);
        label.appendChild(span);
        memberCheckboxesContainer.appendChild(label);

        // 個別チェックボックスのイベント
        checkbox.addEventListener('change', function() {
          if (this.checked) {
            notifyAllCheckbox.checked = false;
          }
        });
      });

      // notified_member_ids が空の場合は「全員に通知」をチェック
      if (existingNotifiedMemberIds.length === 0 && selectedGroup.members.length > 0) {
        notifyAllCheckbox.checked = true;
        document.querySelectorAll('.member-checkbox').forEach(cb => {
          cb.disabled = true;
          cb.checked = false;
        });
      }

      notificationSettings.style.display = 'block';
    }

    // イベントリスナーの重複登録を防ぐ
    groupSelect.removeEventListener('change', updateNotificationSettings);
    groupSelect.addEventListener('change', updateNotificationSettings);

    // 全員通知チェックボックス
    if (notifyAllCheckbox) {
      const handleNotifyAllChange = function() {
        const memberCheckboxes = document.querySelectorAll('.member-checkbox');
        memberCheckboxes.forEach(cb => {
          cb.disabled = this.checked;
          if (this.checked) {
            cb.checked = false;
          }
        });
      };
      notifyAllCheckbox.removeEventListener('change', handleNotifyAllChange);
      notifyAllCheckbox.addEventListener('change', handleNotifyAllChange);
    }

    // 初回表示時
    updateNotificationSettings();
  }

  // 複数のイベントで初期化
  document.addEventListener('turbo:load', initializeNotificationSettings);
  document.addEventListener('turbo:render', initializeNotificationSettings);
  document.addEventListener('DOMContentLoaded', initializeNotificationSettings);
})();
