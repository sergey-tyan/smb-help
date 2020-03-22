import DG from '2gis-maps';

const map = DG.map('map', {
  center: [43.247013, 76.939972],
  zoom: 13,
});

const container = document.querySelector('.categories');
const categoriesMap = categories.reduce(
  (a, b) => ({
    ...a,
    [b]: true,
  }),
  {},
);
categories.forEach(category => {
  const input = document.createElement('input');
  input.type = 'checkbox';
  input.value = category;
  input.id = category;
  input.checked = true;
  input.className = 'mr-3';
  const label = document.createElement('label');
  label.className = 'mr-1';
  label.textContent = category;
  label.htmlFor = category;

  container.appendChild(label);
  container.appendChild(input);
  input.addEventListener('change', e => {
    categoriesMap[category] = e.target.checked;
    showFilteredItems();
  });
});

function intersect(a, b) {
  return a.filter(Set.prototype.has, new Set(b));
}
const markers = DG.featureGroup();
function showFilteredItems() {
  markers.clearLayers();
  const activeCats = categories.filter(cat => categoriesMap[cat]);
  items
    .filter(item => {
      const itemCats = item['Категории'].split(',');
      return intersect(itemCats, activeCats).length > 0;
    })
    .forEach(item => {
      const queryString = item['Ссылка на 2гис'];
      try {
        const items = queryString
          .split('geo/')[1]
          .split('?m')[0]
          .split('/')[1];

        let [lat, lng] = items.split('%2C');
        lat = parseFloat(lat);
        lng = parseFloat(lng);
        const popup = createPopup(item);
        DG.marker([lng, lat])
          .addTo(markers)
          .bindPopup(popup);
        console.log({ item });
      } catch (e) {
        console.log(e);
      }
    });
  markers.addTo(map);
}

function createPopup(item) {
  return `
  <b>${item['Название']}</b>
  <p>${item['Описание']}</p>
  --------------------
  <p>Телефон: ${item['Телефон']}</p>
`;
}

showFilteredItems();
