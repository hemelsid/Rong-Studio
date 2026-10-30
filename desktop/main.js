// Rong Studio for Windows / Mac / Linux: the same editor as the phone app, in its own window, fully offline.
const { app, BrowserWindow, protocol, net, ipcMain, dialog, shell, Menu } = require('electron');
const path = require('path');
const fs = require('fs');
const { pathToFileURL } = require('url');

protocol.registerSchemesAsPrivileged([
  { scheme: 'app', privileges: { standard: true, secure: true, supportFetchAPI: true, corsEnabled: true, stream: true } },
]);

const ASSETS = path.join(__dirname, 'assets');
const IMAGE = /\.(png|jpe?g|webp|gif|bmp)$/i;
let win = null;
let openPath = null; // a picture opened with "Open with → Rong Studio" or dropped on the icon

const pickArg = (argv) => argv.slice(1).find((a) => IMAGE.test(a) && fs.existsSync(a)) || null;

if (!app.requestSingleInstanceLock()) app.quit();

app.on('second-instance', (_e, argv) => {
  if (!win) return;
  if (win.isMinimized()) win.restore();
  win.focus();
  const p = pickArg(argv);
  if (p) { openPath = p; win.webContents.executeJavaScript('window.__openShared && window.__openShared()'); }
});

app.whenReady().then(() => {
  openPath = pickArg(process.argv);

  protocol.handle('app', (req) => {
    const p = decodeURIComponent(new URL(req.url).pathname).replace(/^\/+/, '') || 'index.html';
    if (p === 'shared-image') {
      return openPath ? net.fetch(pathToFileURL(openPath).toString()) : new Response('', { status: 404 });
    }
    const full = path.normalize(path.join(ASSETS, p));
    if (!full.startsWith(ASSETS)) return new Response('', { status: 403 });
    return net.fetch(pathToFileURL(full).toString());
  });

  Menu.setApplicationMenu(null); // the editor has its own menu bar
  win = new BrowserWindow({
    width: 1440, height: 900, minWidth: 900, minHeight: 600,
    title: 'Rong Studio', backgroundColor: '#141210',
    icon: path.join(__dirname, 'icon.png'),
    webPreferences: { preload: path.join(__dirname, 'preload.js'), contextIsolation: true, sandbox: false, spellcheck: false },
  });
  win.webContents.setWindowOpenHandler(({ url }) => { if (/^https?:/.test(url)) shell.openExternal(url); return { action: 'deny' }; });
  win.webContents.on('before-input-event', (e, input) => {
    if (input.type === 'keyDown' && (input.key === 'F11')) { win.setFullScreen(!win.isFullScreen()); e.preventDefault(); }
    if (input.type === 'keyDown' && input.control && input.shift && input.key.toLowerCase() === 'i') { win.webContents.toggleDevTools(); e.preventDefault(); }
  });
  win.loadURL('app://local/index.html');
});

// Save dialog for exported pictures and project files.
ipcMain.on('save-file', (e, name, b64, mime) => {
  try {
    const ext = path.extname(name).slice(1).toLowerCase();
    const dir = /^image\//.test(mime) ? app.getPath('pictures') : app.getPath('documents');
    let target = null;
    if (process.env.RONG_TEST_SAVE_DIR) target = path.join(process.env.RONG_TEST_SAVE_DIR, name);
    else target = dialog.showSaveDialogSync(win, { title: 'Save', defaultPath: path.join(dir, name), filters: [{ name: ext.toUpperCase(), extensions: [ext] }] });
    if (!target) { e.returnValue = 'Save cancelled'; return; }
    fs.writeFileSync(target, Buffer.from(b64, 'base64'));
    e.returnValue = 'Saved: ' + target;
  } catch (err) {
    e.returnValue = 'Could not save';
  }
});
ipcMain.on('has-shared', (e) => { e.returnValue = !!openPath; });

app.on('window-all-closed', () => app.quit());
