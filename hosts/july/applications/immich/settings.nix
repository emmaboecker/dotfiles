{
  ffmpeg = {
    accel = "disabled";
    acceptedAudioCodecs = [
      "aac"
      "mp3"
      "libopus"
    ];
    acceptedVideoCodecs = [ "h264" ];
    bframes = -1;
    cqMode = "auto";
    crf = 23;
    gopSize = 0;
    maxBitrate = "0";
    npl = 0;
    preferredHwDevice = "auto";
    preset = "ultrafast";
    refs = 0;
    targetAudioCodec = "aac";
    targetResolution = "720";
    targetVideoCodec = "h264";
    temporalAQ = false;
    threads = 0;
    tonemap = "hable";
    transcode = "disabled";
    twoPass = false;
  };
  image = {
    colorspace = "p3";
    extractEmbedded = false;
    previewFormat = "jpeg";
    previewSize = 1440;
    quality = 80;
    thumbnailFormat = "webp";
    thumbnailSize = 250;
  };
  job = {
    backgroundTask = {
      concurrency = 5;
    };
    faceDetection = {
      concurrency = 2;
    };
    library = {
      concurrency = 5;
    };
    metadataExtraction = {
      concurrency = 5;
    };
    migration = {
      concurrency = 5;
    };
    search = {
      concurrency = 5;
    };
    sidecar = {
      concurrency = 5;
    };
    smartSearch = {
      concurrency = 2;
    };
    thumbnailGeneration = {
      concurrency = 5;
    };
    videoConversion = {
      concurrency = 1;
    };
  };
  library = {
    scan = {
      cronExpression = "0 0 * * *";
      enabled = true;
    };
    watch = {
      enabled = false;
      interval = 10000;
      usePolling = false;
    };
  };
  logging = {
    enabled = true;
    level = "log";
  };
  machineLearning = {
    clip = {
      enabled = true;
      modelName = "ViT-B-32__openai";
    };
    enabled = true;
    facialRecognition = {
      enabled = true;
      maxDistance = 0.6;
      minFaces = 3;
      minScore = 0.7;
      modelName = "buffalo_l";
    };
    url = "http://127.0.0.1:3003";
  };
  map = {
    enabled = true;
  };
  newVersionCheck = {
    enabled = true;
  };
  oauth = {
    autoLaunch = false;
    autoRegister = true;
    buttonText = "Login with OAuth";
    clientId = "";
    clientSecret = "";
    defaultStorageQuota = 0;
    enabled = false;
    issuerUrl = "";
    mobileOverrideEnabled = false;
    mobileRedirectUri = "";
    scope = "openid email profile";
    signingAlgorithm = "RS256";
    storageLabelClaim = "preferred_username";
    storageQuotaClaim = "immich_quota";
  };
  passwordLogin = {
    enabled = true;
  };
  reverseGeocoding = {
    enabled = true;
  };
  server = {
    externalDomain = "";
    loginPageMessage = "";
  };
  storageTemplate = {
    enabled = true;
    hashVerificationEnabled = true;
    template = "{{y}}/{{y}}-{{MM}}/{{filename}}";
  };
  theme = {
    customCss = "";
  };
  trash = {
    days = 30;
    enabled = true;
  };
  user = {
    deleteDelay = 7;
  };
}
