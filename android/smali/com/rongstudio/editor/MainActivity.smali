.class public Lcom/rongstudio/editor/MainActivity;
.super Landroid/app/Activity;

.field public web:Landroid/webkit/WebView;
.field public cb:Landroid/webkit/ValueCallback;
.field public shared:Landroid/net/Uri;

.method public constructor <init>()V
    .locals 0
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 4
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
    const/4 v0, 0x1
    invoke-virtual {p0, v0}, Lcom/rongstudio/editor/MainActivity;->requestWindowFeature(I)Z
    invoke-virtual {p0}, Lcom/rongstudio/editor/MainActivity;->readShare()V
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v1, 0x1d
    if-ge v0, v1, :noperm
    const/4 v0, 0x1
    new-array v0, v0, [Ljava/lang/String;
    const/4 v1, 0x0
    const-string v2, "android.permission.WRITE_EXTERNAL_STORAGE"
    aput-object v2, v0, v1
    const/4 v1, 0x3
    invoke-virtual {p0, v0, v1}, Lcom/rongstudio/editor/MainActivity;->requestPermissions([Ljava/lang/String;I)V
    :noperm
    new-instance v0, Landroid/webkit/WebView;
    invoke-direct {v0, p0}, Landroid/webkit/WebView;-><init>(Landroid/content/Context;)V
    iput-object v0, p0, Lcom/rongstudio/editor/MainActivity;->web:Landroid/webkit/WebView;
    invoke-virtual {v0}, Landroid/webkit/WebView;->getSettings()Landroid/webkit/WebSettings;
    move-result-object v1
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setJavaScriptEnabled(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDomStorageEnabled(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setDatabaseEnabled(Z)V
    const/4 v2, 0x0
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setAllowFileAccess(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setSupportZoom(Z)V
    invoke-virtual {v1, v2}, Landroid/webkit/WebSettings;->setMediaPlaybackRequiresUserGesture(Z)V
    new-instance v1, Lcom/rongstudio/editor/AssetClient;
    invoke-direct {v1, p0}, Lcom/rongstudio/editor/AssetClient;-><init>(Lcom/rongstudio/editor/MainActivity;)V
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebViewClient(Landroid/webkit/WebViewClient;)V
    new-instance v1, Lcom/rongstudio/editor/Chrome;
    invoke-direct {v1, p0}, Lcom/rongstudio/editor/Chrome;-><init>(Lcom/rongstudio/editor/MainActivity;)V
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->setWebChromeClient(Landroid/webkit/WebChromeClient;)V
    new-instance v1, Lcom/rongstudio/editor/Bridge;
    invoke-direct {v1, p0}, Lcom/rongstudio/editor/Bridge;-><init>(Lcom/rongstudio/editor/MainActivity;)V
    const-string v2, "Android"
    invoke-virtual {v0, v1, v2}, Landroid/webkit/WebView;->addJavascriptInterface(Ljava/lang/Object;Ljava/lang/String;)V
    invoke-virtual {p0, v0}, Lcom/rongstudio/editor/MainActivity;->setContentView(Landroid/view/View;)V
    const-string v1, "https://appassets.androidplatform.net/index.html"
    invoke-virtual {v0, v1}, Landroid/webkit/WebView;->loadUrl(Ljava/lang/String;)V
    return-void
.end method

.method public readShare()V
    .locals 3
    invoke-virtual {p0}, Lcom/rongstudio/editor/MainActivity;->getIntent()Landroid/content/Intent;
    move-result-object v0
    if-eqz v0, :done
    invoke-virtual {v0}, Landroid/content/Intent;->getAction()Ljava/lang/String;
    move-result-object v1
    const-string v2, "android.intent.action.SEND"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :done
    const-string v1, "android.intent.extra.STREAM"
    invoke-virtual {v0, v1}, Landroid/content/Intent;->getParcelableExtra(Ljava/lang/String;)Landroid/os/Parcelable;
    move-result-object v1
    instance-of v2, v1, Landroid/net/Uri;
    if-eqz v2, :done
    check-cast v1, Landroid/net/Uri;
    iput-object v1, p0, Lcom/rongstudio/editor/MainActivity;->shared:Landroid/net/Uri;
    :done
    return-void
.end method

.method protected onActivityResult(IILandroid/content/Intent;)V
    .locals 2
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onActivityResult(IILandroid/content/Intent;)V
    iget-object v0, p0, Lcom/rongstudio/editor/MainActivity;->cb:Landroid/webkit/ValueCallback;
    if-eqz v0, :end
    const/4 v1, 0x0
    iput-object v1, p0, Lcom/rongstudio/editor/MainActivity;->cb:Landroid/webkit/ValueCallback;
    invoke-static {p2, p3}, Landroid/webkit/WebChromeClient$FileChooserParams;->parseResult(ILandroid/content/Intent;)[Landroid/net/Uri;
    move-result-object v1
    invoke-interface {v0, v1}, Landroid/webkit/ValueCallback;->onReceiveValue(Ljava/lang/Object;)V
    :end
    return-void
.end method

.method public onBackPressed()V
    .locals 1
    iget-object v0, p0, Lcom/rongstudio/editor/MainActivity;->web:Landroid/webkit/WebView;
    if-eqz v0, :sup
    invoke-virtual {v0}, Landroid/webkit/WebView;->canGoBack()Z
    move-result v0
    if-eqz v0, :sup
    iget-object v0, p0, Lcom/rongstudio/editor/MainActivity;->web:Landroid/webkit/WebView;
    invoke-virtual {v0}, Landroid/webkit/WebView;->goBack()V
    return-void
    :sup
    invoke-super {p0}, Landroid/app/Activity;->onBackPressed()V
    return-void
.end method
