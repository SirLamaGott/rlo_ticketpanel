$(function() {
  window.addEventListener('message', (event) => {
    const { data } = event;
    if (!data || !data.type) return;

    const actions = {
      'open': () => $('body').removeClass('d-none'),
      'close': () => $('body').addClass('d-none'),
      'removeTicket': () => removeTicket(data.uniqueId),
      'createTicket': () => createTicket(data.ticketContent),
      'syncState': () => changeState(data.ticketContent),
    };

    const action = actions[data.type];
    if (action) action();
  });
});

function createTicket(ticketContent) {
  const { uniqueId, claimedBy, playerName, playerId, reason, time, playerCoords } = ticketContent;

  const createElement = (tag, { className = '', textContent = '', attributes = {} } = {}) => {
    const element = document.createElement(tag);
    if (className) element.className = className;
    if (textContent) element.textContent = textContent;
    Object.entries(attributes).forEach(([key, value]) => element.setAttribute(key, value));
    return element;
  };

  const createButton = (text, className, onClick) => {
    const button = createElement('button', { className, textContent: text });
    button.style.height = '38px';
    button.addEventListener('click', onClick);
    return button;
  };

  const contentHeader = createElement('div', {
    className: 'content-header row mt-1 text-center bor',
    attributes: { 'data-unique-id': uniqueId },
  });

  const col1 = createElement('div', { className: 'col-md-2 column' });
  const img = createElement('img', { attributes: { src: 'image/ticket.svg', alt: 'Icon' } });
  const playerInfo = createElement('div', { textContent: `${playerName} [${playerId}]` });
  col1.append(img, playerInfo);

  const col2 = createElement('div', { className: 'col-md-3 column', textContent: reason });

  const col5 = createElement('div', { className: 'col-sm column align-items-center justify-content-center', textContent: `${time} Uhr` });

  const col3 = createElement('div', { className: 'col-md-2 column' });
  const buttonOpen = createButton(claimedBy, 'btn btn-success me-2 d-flex align-items-center justify-content-center');
  col3.appendChild(buttonOpen);
  
  const col4 = createElement('div', { className: 'column' });
  const buttonClaim = createButton('Claim', 'btn btn-info me-2 d-flex align-items-center justify-content-center', () => {
    fetch(`https://${GetParentResourceName()}/syncState`, {
      method: 'POST',
      body: JSON.stringify(ticketContent),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    }).catch(err => console.error(err));
  });
  
  const buttonTP = createButton('TP', 'btn btn-secondary me-2 d-flex align-items-center justify-content-center', () => teleport(playerId));
  const buttonWP = createButton('WP', 'btn btn-secondary me-2 d-flex align-items-center justify-content-center', () => waypoint(playerCoords));
  const buttonDEL = createButton('DEL', 'btn btn-danger me-2 d-flex align-items-center justify-content-center', () => {
    fetch(`https://${GetParentResourceName()}/syncDelete`, {
      method: 'POST',
      body: JSON.stringify(uniqueId),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    }).catch(err => console.error(err));
  });

  col4.append(buttonClaim, buttonTP, buttonWP, buttonDEL);
  contentHeader.append(col1, col2, col5, col3, col4);

  document.getElementById('content').appendChild(contentHeader);
  console.log('I created a ticket with id: ' + uniqueId)
}

function changeState(ticketContent) {
  const element = document.querySelector(`.content-header[data-unique-id="${ticketContent.uniqueId}"]`);
  if (element) {
    const button = element.querySelector('button.btn-success');
    if (button) {
      console.log(ticketContent.claimedBy);
      button.textContent = ticketContent.claimedBy;
      button.className = 'btn btn-warning me-2 d-flex align-items-center justify-content-center';
    }
  }
}

function teleport(playerId) {
  fetch(`https://${GetParentResourceName()}/teleport`, {
    method: 'POST',
    body: JSON.stringify(playerId),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  }).catch(err => console.error(err));
}

function waypoint(playerCoords) {
  fetch(`https://${GetParentResourceName()}/waypoint`, {
    method: 'POST',
    body: JSON.stringify(playerCoords),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
  }).catch(err => console.error(err));
}

function removeTicket(uniqueId) {
  const element = document.querySelector(`.content-header[data-unique-id="${uniqueId}"]`);
  if (element) {
    element.remove();
  }
}

function closeUi() {
  fetch(`https://${GetParentResourceName()}/close`, {
    method: 'POST',
    headers: {'Content-Type': 'application/json; charset=UTF-8'}
  }).catch(error => console.error('Error:', error));
}