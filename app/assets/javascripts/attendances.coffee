$(document).on 'turbolinks:load', ->
  return unless $('#ranking-sort-mode').length

  selectedOrder = []
  totalMembers = 0

  updateUI = ->
    $('.sort-member-item').each ->
      userId = String($(@).data('user-id'))
      pos = selectedOrder.indexOf(userId)
      if pos >= 0
        $(@).find('.sort-number').text(pos + 1).removeClass('d-none')
        $(@).addClass('list-group-item-primary')
      else
        $(@).find('.sort-number').text('').addClass('d-none')
        $(@).removeClass('list-group-item-primary')

    $('#sort-progress').text(selectedOrder.length + ' / ' + totalMembers + ' 人選択済み')
    $('#sort-save-btn').prop('disabled', selectedOrder.length != totalMembers or totalMembers == 0)

  $('#ranking-sort-btn').on 'click', ->
    selectedOrder = []
    totalMembers = $('.sort-member-item').length
    updateUI()
    $('#ranking-normal').addClass('d-none')
    $(@).addClass('d-none')
    $('#ranking-sort-mode').removeClass('d-none')

  $('#sort-cancel-btn').on 'click', ->
    selectedOrder = []
    $('#ranking-sort-mode').addClass('d-none')
    $('#ranking-normal').removeClass('d-none')
    $('#ranking-sort-btn').removeClass('d-none')

  $(document).on 'click', '.sort-member-item', ->
    userId = String($(@).data('user-id'))
    pos = selectedOrder.indexOf(userId)
    if pos >= 0
      selectedOrder.splice(pos, 1)
    else
      selectedOrder.push(userId)
    updateUI()

  $('#sort-form').on 'submit', ->
    $('#sort-hidden-inputs').empty()
    for userId in selectedOrder
      $('#sort-hidden-inputs').append(
        $('<input>').attr(type: 'hidden', name: 'user_ids[]', value: userId)
      )
