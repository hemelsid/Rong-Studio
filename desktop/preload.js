// The editor talks to the phone app through window.Android; the desktop app answers the same calls.
const { contextBridge, ipcRenderer } = require('electron');
contextBridge.exposeInMainWorld('Android', {
  saveFile: (name, b64, mime) => ipcRenderer.sendSync('save-file', name, b64, mime),
  hasShared: () => ipcRenderer.sendSync('has-shared'),
});
contextBridge.exposeInMainWorld('RongDesktop', { platform: process.platform });
