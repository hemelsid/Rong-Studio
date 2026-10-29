.class public Lcom/rongstudio/editor/AssetClient;
.super Landroid/webkit/WebViewClient;

.field public act:Lcom/rongstudio/editor/MainActivity;

.method public constructor <init>(Lcom/rongstudio/editor/MainActivity;)V
    .locals 0
    invoke-direct {p0}, Landroid/webkit/WebViewClient;-><init>()V
    iput-object p1, p0, Lcom/rongstudio/editor/AssetClient;->act:Lcom/rongstudio/editor/MainActivity;
    return-void
.end method

.method public static mime(Ljava/lang/String;)Ljava/lang/String;
    .locals 2
    const-string v0, ".html"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :nhtml
    const-string v0, "text/html"
    return-object v0
    :nhtml
    const-string v0, ".js"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :njs
    const-string v0, "text/javascript"
    return-object v0
    :njs
    const-string v0, ".css"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :ncss
    const-string v0, "text/css"
    return-object v0
    :ncss
    const-string v0, ".woff2"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :nwoff2
    const-string v0, "font/woff2"
    return-object v0
    :nwoff2
    const-string v0, ".png"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :npng
    const-string v0, "image/png"
    return-object v0
    :npng
    const-string v0, ".json"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :njson
    const-string v0, "application/json"
    return-object v0
    :njson
    const-string v0, ".wasm"
    invoke-virtual {p0, v0}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z
    move-result v1
    if-eqz v1, :nwasm
    const-string v0, "application/wasm"
    return-object v0
    :nwasm
    const-string v0, "application/octet-stream"
    return-object v0
.end method

.method public shouldInterceptRequest(Landroid/webkit/WebView;Landroid/webkit/WebResourceRequest;)Landroid/webkit/WebResourceResponse;
    .locals 6
    :try_start
    invoke-interface {p2}, Landroid/webkit/WebResourceRequest;->getUrl()Landroid/net/Uri;
    move-result-object v0
    invoke-virtual {v0}, Landroid/net/Uri;->getHost()Ljava/lang/String;
    move-result-object v1
    const-string v2, "appassets.androidplatform.net"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v1
    if-eqz v1, :nope
    invoke-virtual {v0}, Landroid/net/Uri;->getPath()Ljava/lang/String;
    move-result-object v1
    if-eqz v1, :nope
    const/4 v2, 0x1
    invoke-virtual {v1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;
    move-result-object v1
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z
    move-result v2
    if-eqz v2, :named
    const-string v1, "index.html"
    :named
    iget-object v3, p0, Lcom/rongstudio/editor/AssetClient;->act:Lcom/rongstudio/editor/MainActivity;
    const-string v2, "shared-image"
    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :asset
    iget-object v4, v3, Lcom/rongstudio/editor/MainActivity;->shared:Landroid/net/Uri;
    if-eqz v4, :nope
    invoke-virtual {v3}, Lcom/rongstudio/editor/MainActivity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v5
    invoke-virtual {v5, v4}, Landroid/content/ContentResolver;->openInputStream(Landroid/net/Uri;)Ljava/io/InputStream;
    move-result-object v4
    const-string v2, "image/jpeg"
    goto :resp
    :asset
    invoke-virtual {v3}, Lcom/rongstudio/editor/MainActivity;->getAssets()Landroid/content/res/AssetManager;
    move-result-object v4
    invoke-virtual {v4, v1}, Landroid/content/res/AssetManager;->open(Ljava/lang/String;)Ljava/io/InputStream;
    move-result-object v4
    invoke-static {v1}, Lcom/rongstudio/editor/AssetClient;->mime(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v2
    :resp
    new-instance v5, Landroid/webkit/WebResourceResponse;
    const/4 v1, 0x0
    invoke-direct {v5, v2, v1, v4}, Landroid/webkit/WebResourceResponse;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/InputStream;)V
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :caught
    return-object v5
    :nope
    const/4 v0, 0x0
    return-object v0
    :caught
    const/4 v0, 0x0
    return-object v0
.end method
