.class public Lcom/rongstudio/editor/Bridge;
.super Ljava/lang/Object;

.field public act:Lcom/rongstudio/editor/MainActivity;

.method public constructor <init>(Lcom/rongstudio/editor/MainActivity;)V
    .locals 0
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    iput-object p1, p0, Lcom/rongstudio/editor/Bridge;->act:Lcom/rongstudio/editor/MainActivity;
    return-void
.end method

.method public hasShared()Z
    .locals 1
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    iget-object v0, p0, Lcom/rongstudio/editor/Bridge;->act:Lcom/rongstudio/editor/MainActivity;
    iget-object v0, v0, Lcom/rongstudio/editor/MainActivity;->shared:Landroid/net/Uri;
    if-eqz v0, :no
    const/4 v0, 0x1
    return v0
    :no
    const/4 v0, 0x0
    return v0
.end method

.method public saveFile(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .locals 7
    .annotation runtime Landroid/webkit/JavascriptInterface;
    .end annotation
    :try_start
    const/4 v0, 0x0
    invoke-static {p2, v0}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B
    move-result-object v0
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I
    const/16 v2, 0x1d
    if-ge v1, v2, :modern
    const-string v2, "image/"
    invoke-virtual {p3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    if-eqz v2, :ldl
    sget-object v3, Landroid/os/Environment;->DIRECTORY_PICTURES:Ljava/lang/String;
    const-string v6, "\u0997\u09cd\u09af\u09be\u09b2\u09be\u09b0\u09bf\u09a4\u09c7 \u09b8\u09c7\u09ad \u09b9\u09af\u09bc\u09c7\u099b\u09c7 (Pictures/Rong Studio)"
    goto :lgo
    :ldl
    sget-object v3, Landroid/os/Environment;->DIRECTORY_DOWNLOADS:Ljava/lang/String;
    const-string v6, "Download/Rong Studio \u09ab\u09cb\u09b2\u09cd\u09a1\u09be\u09b0\u09c7 \u09b8\u09c7\u09ad \u09b9\u09af\u09bc\u09c7\u099b\u09c7"
    :lgo
    invoke-static {v3}, Landroid/os/Environment;->getExternalStoragePublicDirectory(Ljava/lang/String;)Ljava/io/File;
    move-result-object v3
    new-instance v4, Ljava/io/File;
    const-string v5, "Rong Studio"
    invoke-direct {v4, v3, v5}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    invoke-virtual {v4}, Ljava/io/File;->mkdirs()Z
    new-instance v3, Ljava/io/File;
    invoke-direct {v3, v4, p1}, Ljava/io/File;-><init>(Ljava/io/File;Ljava/lang/String;)V
    new-instance v4, Ljava/io/FileOutputStream;
    invoke-direct {v4, v3}, Ljava/io/FileOutputStream;-><init>(Ljava/io/File;)V
    invoke-virtual {v4, v0}, Ljava/io/FileOutputStream;->write([B)V
    invoke-virtual {v4}, Ljava/io/FileOutputStream;->close()V
    const/4 v4, 0x1
    new-array v4, v4, [Ljava/lang/String;
    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;
    move-result-object v3
    const/4 v5, 0x0
    aput-object v3, v4, v5
    iget-object v3, p0, Lcom/rongstudio/editor/Bridge;->act:Lcom/rongstudio/editor/MainActivity;
    const/4 v5, 0x0
    invoke-static {v3, v4, v5, v5}, Landroid/media/MediaScannerConnection;->scanFile(Landroid/content/Context;[Ljava/lang/String;[Ljava/lang/String;Landroid/media/MediaScannerConnection$OnScanCompletedListener;)V
    goto :done
    :modern
    new-instance v1, Landroid/content/ContentValues;
    invoke-direct {v1}, Landroid/content/ContentValues;-><init>()V
    const-string v2, "_display_name"
    invoke-virtual {v1, v2, p1}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "mime_type"
    invoke-virtual {v1, v2, p3}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V
    const-string v2, "image/"
    invoke-virtual {p3, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v2
    const-string v3, "relative_path"
    if-eqz v2, :dl
    const-string v4, "Pictures/Rong Studio"
    invoke-virtual {v1, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V
    sget-object v5, Landroid/provider/MediaStore$Images$Media;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;
    const-string v6, "\u0997\u09cd\u09af\u09be\u09b2\u09be\u09b0\u09bf\u09a4\u09c7 \u09b8\u09c7\u09ad \u09b9\u09af\u09bc\u09c7\u099b\u09c7 (Pictures/Rong Studio)"
    goto :ins
    :dl
    const-string v4, "Download/Rong Studio"
    invoke-virtual {v1, v3, v4}, Landroid/content/ContentValues;->put(Ljava/lang/String;Ljava/lang/String;)V
    sget-object v5, Landroid/provider/MediaStore$Downloads;->EXTERNAL_CONTENT_URI:Landroid/net/Uri;
    const-string v6, "Download/Rong Studio \u09ab\u09cb\u09b2\u09cd\u09a1\u09be\u09b0\u09c7 \u09b8\u09c7\u09ad \u09b9\u09af\u09bc\u09c7\u099b\u09c7"
    :ins
    iget-object v2, p0, Lcom/rongstudio/editor/Bridge;->act:Lcom/rongstudio/editor/MainActivity;
    invoke-virtual {v2}, Lcom/rongstudio/editor/MainActivity;->getContentResolver()Landroid/content/ContentResolver;
    move-result-object v2
    invoke-virtual {v2, v5, v1}, Landroid/content/ContentResolver;->insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    move-result-object v3
    if-eqz v3, :bad
    invoke-virtual {v2, v3}, Landroid/content/ContentResolver;->openOutputStream(Landroid/net/Uri;)Ljava/io/OutputStream;
    move-result-object v4
    if-eqz v4, :bad
    invoke-virtual {v4, v0}, Ljava/io/OutputStream;->write([B)V
    invoke-virtual {v4}, Ljava/io/OutputStream;->close()V
    :done
    nop
    :try_end
    .catch Ljava/lang/Throwable; {:try_start .. :try_end} :caught
    return-object v6
    :bad
    const-string v0, "\u09b8\u09c7\u09ad \u0995\u09b0\u09be \u0997\u09c7\u09b2 \u09a8\u09be"
    return-object v0
    :caught
    const-string v0, "\u09b8\u09c7\u09ad \u0995\u09b0\u09be \u0997\u09c7\u09b2 \u09a8\u09be"
    return-object v0
.end method
