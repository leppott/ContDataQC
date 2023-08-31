# Developed by David Gibbs, ORISE fellow at the US EPA Office of Research & Development.
# dagibbs22@gmail.com
# Erik.Leppo@tetratech.com
# Written 2017 and 2018 (mostly David)
# Updated 2020 (Erik)
# 2021-04-19, Erik, modular format
# 2021-06-15, Ben Block, updated formatting
# 2022-08-11, Erik, rework tab layout

# Source ----

tab_1_About      <- source("external/tab_1_About.R", local = TRUE)$value
tab_1a_Overview  <- source("external/tab_1a_Overview.R", local = TRUE)$value
tab_1b_TestData  <- source("external/tab_1b_TestData.R", local = TRUE)$value
tab_1c_FAQ       <- source("external/tab_1c_FAQ.R", local = TRUE)$value
tab_2_DataPrep   <- source("external/tab_2_DataPrep.R", local = TRUE)$value
tab_3_MainFunc   <- source("external/tab_3_MainFunc.R", local = TRUE)$value
tab_3c_QCThresh  <- source("external/tab_3c_QCThresh.R", local = TRUE)$value
tab_4_USGSgage   <- source("external/tab_4_USGSgage.R", local = TRUE)$value
tab_5_Troubleshooting <- source("external/tab_5_Troubleshooting.R"
                               , local = TRUE)$value
tab_5b_Console    <- source("external/tab_5b_Console.R", local = TRUE)$value
#tab_9_Status     <- source("external/tab_9_Status.R", local = TRUE)$value


shinyUI(
  # VERSION, 1, current [non-EPA] ----
  navbarPage("Continuous data QC, summary, and statistics - v2.0.7.9012",
             theme = shinytheme("spacelab")
             ,tab_1_About()
             #,tab_1a_Overview()
             #,tab_1c_FAQ()
             , tab_2_DataPrep()
             , tab_3_MainFunc()
             #,tab_3c_QCThresh()
             , tab_4_USGSgage()
             , tab_5_Troubleshooting()
             #,tab_5b_Console()
             #,tab_x_TestData()
             #,tab_9_Status()
  )## navbarPage ~ END
)## shinyUI ~ END

# shinyUI(
#   # VERSION, 0, old ----
#   navbarPage("Continuous data QC, summary, and statistics - v2.0.6",
#              theme= shinytheme("spacelab"),
#              #also liked "cerulean" at https://rstudio.github.io/shinythemes/
#              # tabPan, Site Intro
#              tab_Intro(),
#              # tabPan, Calc
#              tab_Calc(),
#              # tabPan, Adv Feat
#              tab_Console(),
#              tab_Config(),
#              tab_Reformat(),
#              # tabPan, USGS
#              tab_USGSgage() ,
#              # tabPan, FAQ
#              tab_FAQ()
#
#   )## navbarPage ~ END
# )## shinyUI ~ END

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# VERSION, EPA Template ----
# 2022-09-15
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# shinyUI(
#   fluidPage(
#     tags$html(class = "no-js", lang="en"),
#     tags$head(
#       HTML(
#         "<!-- Google Tag Manager -->
#   		<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
#   		new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
#   		j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
#   		'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
#   		})(window,document,'script','dataLayer','GTM-L8ZB');</script>
#   		<!-- End Google Tag Manager -->
#   		"
#       ),
#       tags$meta(charset="utf-8"),
#       tags$meta(property="og:site_name", content="US EPA"),
#       #tags$link(rel = "stylesheet", type = "text/css", href = "css/uswds.css"),
#       tags$link(rel = "stylesheet", type = "text/css", href = "https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/css/uswds.min.css", integrity="sha512-ZKvR1/R8Sgyx96aq5htbFKX84hN+zNXN73sG1dEHQTASpNA8Pc53vTbPsEKTXTZn9J4G7R5Il012VNsDEReqCA==", crossorigin="anonymous", referrerpolicy="no-referrer"),
#       tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
#       tags$link(rel="canonical", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
#       tags$link(rel="shortlink", href="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
#       tags$meta(property="og:url", content="https://www.epa.gov/themes/epa_theme/pattern-lab/.markup-only.html"),
#       tags$meta(property="og:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-og.jpg"),
#       tags$meta(property="og:image:width", content="1200"),
#       tags$meta(property="og:image:height", content="630"),
#       tags$meta(property="og:image:alt", content="U.S. Environmental Protection Agency"),
#       tags$meta(name="twitter:card", content="summary_large_image"),
#       tags$meta(name="twitter:image:alt", content="U.S. Environmental Protection Agency"),
#       tags$meta(name="twitter:image:height", content="600"),
#       tags$meta(name="twitter:image:width", content="1200"),
#       tags$meta(name="twitter:image", content="https://www.epa.gov/sites/all/themes/epa/img/epa-standard-twitter.jpg"),
#       tags$meta(name="MobileOptimized", content="width"),
#       tags$meta(name="HandheldFriendly", content="true"),
#       tags$meta(name="viewport", content="width=device-width, initial-scale=1.0"),
#       tags$meta(`http-equiv`="x-ua-compatible", content="ie=edge"),
#       tags$script(src = "js/pattern-lab-head-script.js"),
#       # _update title ----
#       tags$title('ContDataQC | US EPA'),
#       tags$link(rel="icon", type="image/x-icon", href="https://www.epa.gov/themes/epa_theme/images/favicon.ico"),
#       tags$meta(name="msapplication-TileColor", content="#FFFFFF"),
#       tags$meta(name="msapplication-TileImage", content="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
#       tags$meta(name="application-name", content=""),
#       tags$meta(name="msapplication-config", content="https://www.epa.gov/themes/epa_theme/images/ieconfig.xml"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="196x196", href="https://www.epa.gov/themes/epa_theme/images/favicon-196.png"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="152x152", href="https://www.epa.gov/themes/epa_theme/images/favicon-152.png"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="144x144", href="https://www.epa.gov/themes/epa_theme/images/favicon-144.png"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="120x120", href="https://www.epa.gov/themes/epa_theme/images/favicon-120.png"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="114x114", href="https://www.epa.gov/themes/epa_theme/images/favicon-114.png"),
#       tags$link(rel="apple-touch-icon-precomposed", sizes="72x72", href="https://www.epa.gov/themes/epa_theme/images/favicon-72.png"),
#       tags$link(rel="apple-touch-icon-precomposed", href="https://www.epa.gov/themes/epa_theme/images/favicon-180.png"),
#       tags$link(rel="icon", href="https://www.epa.gov/themes/epa_theme/images/favicon-32.png", sizes="32x32"),
#       tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-regular-webfont.woff2", as="font", crossorigin="anonymous"),
#       tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/source-sans-pro/sourcesanspro-bold-webfont.woff2", as="font", crossorigin="anonymous"),
#       tags$link(rel="preload", href="https://www.epa.gov/themes/epa_theme/fonts/merriweather/Latin-Merriweather-Bold.woff2", as="font", crossorigin="anonymous"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/ajax-progress.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/autocomplete-loading.module.css?r6lsex" ),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/js.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/sticky-header.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-counter.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-counters.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/system-status-report-general-info.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tabledrag.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tablesort.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/core/themes/stable/css/system/components/tree-child.module.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css/styles.css?r6lsex"),
#       tags$link(rel="stylesheet", media="all", href="https://www.epa.gov/themes/epa_theme/css-lib/colorbox.min.css?r6lsex"),
#
#       tags$script(src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds-init.min.js'),
#       #fix container-fluid that boostrap RShiny uses
#       tags$style(HTML(
#         '.container-fluid {
#               padding-right: 0;
#               padding-left: 0;
#               margin-right: 0;
#               margin-left: 0;
#           }
#           .tab-content {
#               margin-right: 30px;
#               margin-left: 30px;
#           }'
#       ))
#     ),
#     tags$body(
#       class="path-themes not-front has-wide-template", id="top",
#       tags$script(
#         src = 'https://cdnjs.cloudflare.com/ajax/libs/uswds/3.0.0-beta.3/js/uswds.min.js'
#       )
#     ),
#
#     # Site Header
#     HTML(
#       '<div class="skiplinks" role="navigation" aria-labelledby="skip-to-main">
#         <a id="skip-to-main" href="#main" class="skiplinks__link visually-hidden focusable">Skip to main content</a>
#       </div>
#
#   	<!-- Google Tag Manager (noscript) -->
#   	<noscript><iframe src=https://www.googletagmanager.com/ns.html?id=GTM-L8ZB
#   	height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
#   	<!-- End Google Tag Manager (noscript) -->
#
#       <div class="dialog-off-canvas-main-canvas" data-off-canvas-main-canvas>
#       <section class="usa-banner" aria-label="Official government website">
#         <div class="usa-accordion">
#           <header class="usa-banner__header">
#             <div class="usa-banner__inner">
#               <div class="grid-col-auto">
#                 <img class="usa-banner__header-flag" src="https://www.epa.gov/themes/epa_theme/images/us_flag_small.png" alt="U.S. flag" />
#               </div>
#               <div class="grid-col-fill tablet:grid-col-auto">
#                 <p class="usa-banner__header-text">An official website of the United States government</p>
#                 <p class="usa-banner__header-action" aria-hidden="true">Here’s how you know</p>
#               </div>
#               <button class="usa-accordion__button usa-banner__button" aria-expanded="false" aria-controls="gov-banner">
#                 <span class="usa-banner__button-text">Here’s how you know</span>
#               </button>
#             </div>
#           </header>
#           <div class="usa-banner__content usa-accordion__content" id="gov-banner">
#             <div class="grid-row grid-gap-lg">
#               <div class="usa-banner__guidance tablet:grid-col-6">
#                 <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-dot-gov.svg" alt="Dot gov">
#                 <div class="usa-media-block__body">
#                   <p>
#                     <strong>Official websites use .gov</strong>
#                     <br> A <strong>.gov</strong> website belongs to an official government organization in the United States.
#                   </p>
#                 </div>
#               </div>
#               <div class="usa-banner__guidance tablet:grid-col-6">
#                 <img class="usa-banner__icon usa-media-block__img" src="https://www.epa.gov/themes/epa_theme/images/icon-https.svg" alt="HTTPS">
#                 <div class="usa-media-block__body">
#                   <p>
#                     <strong>Secure .gov websites use HTTPS</strong>
#                     <br> A <strong>lock</strong> (<span class="icon-lock"><svg xmlns="http://www.w3.org/2000/svg" width="52" height="64" viewBox="0 0 52 64" class="usa-banner__lock-image" role="img" aria-labelledby="banner-lock-title banner-lock-description"><title id="banner-lock-title">Lock</title><desc id="banner-lock-description">A locked padlock</desc><path fill="#000000" fill-rule="evenodd" d="M26 0c10.493 0 19 8.507 19 19v9h3a4 4 0 0 1 4 4v28a4 4 0 0 1-4 4H4a4 4 0 0 1-4-4V32a4 4 0 0 1 4-4h3v-9C7 8.507 15.507 0 26 0zm0 8c-5.979 0-10.843 4.77-10.996 10.712L15 19v9h22v-9c0-6.075-4.925-11-11-11z"/></svg></span>) or <strong>https://</strong> means you’ve safely connected to the .gov website. Share sensitive information only on official, secure websites.
#                   </p>
#                 </div>
#               </div>
#             </div>
#           </div>
#         </div>
#       </section>
#       <div>
#         <div class="js-view-dom-id-epa-alerts--public">
#           <noscript>
#             <div class="usa-site-alert usa-site-alert--info">
#               <div class="usa-alert">
#                 <div class="usa-alert__body">
#                   <div class="usa-alert__text">
#                     <p>JavaScript appears to be disabled on this computer. Please <a href="/alerts">click here to see any active alerts</a>.</p>
#                   </div>
#                 </div>
#               </div>
#             </div>
#           </noscript>
#         </div>
#       </div>
#       <header class="l-header">
#         <div class="usa-overlay"></div>
#         <div class="l-constrain">
#           <div class="l-header__navbar">
#             <div class="l-header__branding">
#               <a class="site-logo" href="/" aria-label="Home" title="Home" rel="home">
#                 <span class="site-logo__image">
#                   <svg class="site-logo__svg" viewBox="0 0 1061 147" aria-hidden="true" xmlns="http://www.w3.org/2000/svg">
#                     <path d="M112.8 53.5C108 72.1 89.9 86.8 69.9 86.8c-20.1 0-38-14.7-42.9-33.4h.2s9.8 10.3-.2 0c3.1 3.1 6.2 4.4 10.7 4.4s7.7-1.3 10.7-4.4c3.1 3.1 6.3 4.5 10.9 4.4 4.5 0 7.6-1.3 10.7-4.4 3.1 3.1 6.2 4.4 10.7 4.4 4.5 0 7.7-1.3 10.7-4.4 3.1 3.1 6.3 4.5 10.9 4.4 4.3 0 7.4-1.2 10.5-4.3zM113.2 43.5c0-24-19.4-43.5-43.3-43.5-24 0-43.5 19.5-43.5 43.5h39.1c-4.8-1.8-8.1-6.3-8.1-11.6 0-7 5.7-12.5 12.5-12.5 7 0 12.7 5.5 12.7 12.5 0 5.2-3.1 9.6-7.6 11.6h38.2zM72.6 139.3c.7-36.9 29.7-68.8 66.9-70 0 37.2-30 68-66.9 70zM67.1 139.3c-.7-36.9-29.7-68.8-67.1-70 0 37.2 30.2 68 67.1 70zM240 3.1h-87.9v133.1H240v-20.4h-60.3v-36H240v-21h-60.3v-35H240V3.1zM272.8 58.8h27.1c9.1 0 15.2-8.6 15.1-17.7-.1-9-6.1-17.3-15.1-17.3h-25.3v112.4h-27.8V3.1h62.3c20.2 0 35 17.8 35.2 38 .2 20.4-14.8 38.7-35.2 38.7h-36.3v-21zM315.9 136.2h29.7l12.9-35h54.2l-8.1-21.9h-38.4l18.9-50.7 39.2 107.6H454L400.9 3.1h-33.7l-51.3 133.1zM473.3.8v22.4c0 1.9.2 3.3.5 4.3s.7 1.7 1 2.2c1.2 1.4 2.5 2.4 3.9 2.9 1.5.5 2.8.7 4.1.7 2.4 0 4.2-.4 5.5-1.3 1.3-.8 2.2-1.8 2.8-2.9.6-1.1.9-2.3 1-3.4.1-1.1.1-2 .1-2.6V.8h4.7v24c0 .7-.1 1.5-.4 2.4-.3 1.8-1.2 3.6-2.5 5.4-1.8 2.1-3.8 3.5-6 4.2-2.2.6-4 .9-5.3.9-1.8 0-3.8-.3-6.2-1.1-2.4-.8-4.5-2.3-6.2-4.7-.5-.8-1-1.8-1.4-3.2-.4-1.3-.6-3.3-.6-5.9V.8h5zM507.5 14.5v-2.9l4.6.1-.1 4.1c.2-.3.4-.7.8-1.2.3-.5.8-.9 1.4-1.4.6-.5 1.4-.9 2.3-1.3.9-.3 2.1-.5 3.4-.4.6 0 1.4.1 2.4.3.9.2 1.9.6 2.9 1.2s1.8 1.5 2.4 2.6c.6 1.2.9 2.8.9 4.7l-.4 17-4.6-.1.4-16c0-.9 0-1.7-.2-2.4-.1-.7-.5-1.3-1.1-1.9-1.2-1.2-2.6-1.8-4.3-1.8-1.7 0-3.1.5-4.4 1.7-1.3 1.2-2 3.1-2.1 5.7l-.3 14.5-4.5-.1.5-22.4zM537.2.9h5.5V6h-5.5V.9m.5 10.9h4.6v25.1h-4.6V11.8zM547.8 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM570.9 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM612.9.9h4.6V33c0 1 .1 2.3.2 4h-4.6l-.1-4c-.2.3-.4.7-.7 1.2-.3.5-.8 1-1.4 1.5-1 .7-2 1.2-3.1 1.4l-1.5.3c-.5.1-.9.1-1.4.1-.4 0-.8 0-1.3-.1s-1.1-.2-1.7-.3c-1.1-.3-2.3-.9-3.4-1.8s-2.1-2.2-2.9-3.8c-.8-1.7-1.2-3.9-1.2-6.6.1-4.8 1.2-8.3 3.4-10.5 2.1-2.1 4.7-3.2 7.6-3.2 1.3 0 2.4.2 3.4.5.9.3 1.6.7 2.2 1.2.6.4 1 .9 1.3 1.4.3.5.6.8.7 1.1V.9m0 23.1c0-1.9-.2-3.3-.5-4.4-.4-1.1-.8-2-1.4-2.6-.5-.7-1.2-1.3-2-1.8-.9-.5-2-.7-3.3-.7-1.7 0-2.9.5-3.8 1.3-.9.8-1.6 1.9-2 3.1-.4 1.2-.7 2.3-.7 3.4-.1 1.1-.2 1.9-.1 2.4 0 1.1.1 2.2.3 3.4.2 1.1.5 2.2 1 3.1.5 1 1.2 1.7 2 2.3.9.6 2 .9 3.3.9 1.8 0 3.2-.5 4.2-1.4 1-.8 1.7-1.8 2.1-3 .4-1.2.7-2.4.8-3.4.1-1.4.1-2.1.1-2.6zM643.9 26.4c0 .6.1 1.3.3 2.1.1.8.5 1.6 1 2.3.5.8 1.4 1.4 2.5 1.9s2.7.8 4.7.8c1.8 0 3.3-.3 4.4-.8 1.1-.5 1.9-1.1 2.5-1.8.6-.7 1-1.5 1.1-2.2.1-.7.2-1.2.2-1.7 0-1-.2-1.9-.5-2.6-.4-.6-.9-1.2-1.6-1.6-1.4-.8-3.4-1.4-5.9-2-4.9-1.1-8.1-2.2-9.5-3.2-1.4-1-2.3-2.2-2.9-3.5-.6-1.2-.8-2.4-.8-3.6.1-3.7 1.5-6.4 4.2-8.1 2.6-1.7 5.7-2.5 9.1-2.5 1.3 0 2.9.2 4.8.5 1.9.4 3.6 1.4 5 3 .5.5.9 1.1 1.2 1.7.3.5.5 1.1.6 1.6.2 1.1.3 2.1.3 2.9h-5c-.2-2.2-1-3.7-2.4-4.5-1.5-.7-3.1-1.1-4.9-1.1-5.1.1-7.7 2-7.8 5.8 0 1.5.5 2.7 1.6 3.5 1 .8 2.6 1.4 4.7 1.9 4 1 6.7 1.8 8.1 2.2.8.2 1.4.5 1.8.7.5.2 1 .5 1.4.9.8.5 1.4 1.1 1.9 1.8s.8 1.4 1.1 2.1c.3 1.4.5 2.5.5 3.4 0 3.3-1.2 6-3.5 8-2.3 2.1-5.8 3.2-10.3 3.3-1.4 0-3.2-.3-5.4-.8-1-.3-2-.7-3-1.2-.9-.5-1.8-1.2-2.5-2.1-.9-1.4-1.5-2.7-1.7-4.1-.3-1.3-.4-2.4-.3-3.2h5zM670 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1H670v-3.4zM705.3 36.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM714.5 11.7h4.3V6.4l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V37c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V15.1h-4.3v-3.4zM737.6 25.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM765.3 29.5c0 .5.1 1 .2 1.4.1.5.4 1 .8 1.5s.9.8 1.6 1.1c.7.3 1.6.5 2.7.5 1 0 1.8-.1 2.5-.3.7-.2 1.3-.6 1.7-1.2.5-.7.8-1.5.8-2.4 0-1.2-.4-2-1.3-2.5s-2.2-.9-4.1-1.2c-1.3-.3-2.4-.6-3.6-1-1.1-.3-2.1-.8-3-1.3-.9-.5-1.5-1.2-2-2.1-.5-.8-.8-1.9-.8-3.2 0-2.4.9-4.2 2.6-5.6 1.7-1.3 4-2 6.8-2.1 1.6 0 3.3.3 5 .8 1.7.6 2.9 1.6 3.7 3.1.4 1.4.6 2.6.6 3.7h-4.6c0-1.8-.6-3-1.7-3.5-1.1-.4-2.1-.6-3.1-.6h-1c-.5 0-1.1.2-1.7.4-.6.2-1.1.5-1.5 1.1-.5.5-.7 1.2-.7 2.1 0 1.1.5 1.9 1.3 2.3.7.4 1.5.7 2.1.9 3.3.7 5.6 1.3 6.9 1.8 1.3.4 2.2 1 2.8 1.7.7.7 1.1 1.4 1.4 2.2.3.8.4 1.6.4 2.5 0 1.4-.3 2.7-.9 3.8-.6 1.1-1.4 2-2.4 2.6-1.1.6-2.2 1-3.4 1.3-1.2.3-2.5.4-3.8.4-2.5 0-4.7-.6-6.6-1.8-1.8-1.2-2.8-3.3-2.9-6.3h5.2zM467.7 50.8h21.9V55h-17.1v11.3h16.3v4.2h-16.3v12.1H490v4.3h-22.3zM499 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87H499V64.7zM524.6 61.8h5.1l7.7 19.9 7.6-19.9h5l-10.6 25.1h-4.6zM555.7 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1h-4.6V61.8zM570.3 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3h-4.6V67zM587.6 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM620.2 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM650 65.1l-.1-3.3h4.6v3.6c1.2-1.9 2.6-3.2 4.1-3.7 1.5-.4 2.7-.6 3.8-.6 1.4 0 2.6.2 3.6.5.9.3 1.7.7 2.3 1.1 1.1 1 1.9 2 2.3 3.1.2-.4.5-.8 1-1.3.4-.5.9-1 1.5-1.6.6-.5 1.5-.9 2.5-1.3 1-.3 2.2-.5 3.5-.5.9 0 1.9.1 3 .3 1 .2 2 .7 3 1.3 1 .6 1.7 1.5 2.3 2.7.6 1.2.9 2.7.9 4.6v16.9h-4.6V70.7c0-1.1-.1-2-.2-2.5-.1-.6-.3-1-.6-1.3-.4-.6-1-1.2-1.8-1.6-.8-.4-1.8-.6-3.1-.6-1.5 0-2.7.4-3.6 1-.4.3-.8.5-1.1.9l-.8.8c-.5.8-.8 1.8-1 2.8-.1 1.1-.2 2-.1 2.6v14.1h-4.6V70.2c0-1.6-.5-2.9-1.4-4-.9-1-2.3-1.5-4.2-1.5-1.6 0-2.9.4-3.8 1.1-.9.7-1.5 1.2-1.8 1.7-.5.7-.8 1.5-.9 2.5-.1.9-.2 1.8-.2 2.6v14.3H650V65.1zM700.5 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.8-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM725.7 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM752.3 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM787.6 86.9c-.3-1.2-.5-2.5-.4-3.7-.5 1-1.1 1.8-1.7 2.4-.7.6-1.4 1.1-2 1.4-1.4.5-2.7.8-3.7.8-2.8 0-4.9-.8-6.4-2.2-1.5-1.4-2.2-3.1-2.2-5.2 0-1 .2-2.3.8-3.7.6-1.4 1.7-2.6 3.5-3.7 1.4-.7 2.9-1.2 4.5-1.5 1.6-.1 2.9-.2 3.9-.2s2.1 0 3.3.1c.1-2.9-.2-4.8-.9-5.6-.5-.6-1.1-1.1-1.9-1.3-.8-.2-1.6-.4-2.3-.4-1.1 0-2 .2-2.6.5-.7.3-1.2.7-1.5 1.2-.3.5-.5.9-.6 1.4-.1.5-.2.9-.2 1.2h-4.6c.1-.7.2-1.4.4-2.3.2-.8.6-1.6 1.3-2.5.5-.6 1-1 1.7-1.3.6-.3 1.3-.6 2-.8 1.5-.4 2.8-.6 4.2-.6 1.8 0 3.6.3 5.2.9 1.6.6 2.8 1.6 3.4 2.9.4.7.6 1.4.7 2 .1.6.1 1.2.1 1.8l-.2 12c0 1 .1 3.1.4 6.3h-4.2m-.5-12.1c-.7-.1-1.6-.1-2.6-.1h-2.1c-1 .1-2 .3-3 .6s-1.9.8-2.6 1.5c-.8.7-1.2 1.7-1.2 3 0 .4.1.8.2 1.3s.4 1 .8 1.5.9.8 1.6 1.1c.7.3 1.5.5 2.5.5 2.3 0 4.1-.9 5.2-2.7.5-.8.8-1.7 1-2.7.1-.9.2-2.2.2-4zM800.7 50.9h4.6V87h-4.6zM828.4 50.8h11.7c2.1 0 3.9.1 5.5.4.8.2 1.5.4 2.2.9.7.4 1.3.9 1.8 1.6 1.7 1.9 2.6 4.2 2.6 7 0 2.7-.9 5.1-2.8 7.1-.8.9-2 1.7-3.6 2.2-1.6.6-3.9.9-6.9.9h-5.7V87h-4.8V50.8m4.8 15.9h5.8c.8 0 1.7-.1 2.6-.2.9-.1 1.8-.3 2.6-.7.8-.4 1.5-1 2-1.9.5-.8.8-2 .8-3.4s-.2-2.5-.7-3.3c-.5-.8-1.1-1.3-1.9-1.7-1.6-.5-3.1-.8-4.5-.7h-6.8v11.9zM858.1 67c0-1.8-.1-3.5-.3-5.1h4.6l.1 4.9c.5-1.8 1.4-3 2.5-3.7 1.1-.7 2.2-1.2 3.3-1.3 1.4-.2 2.4-.2 3.1-.1v4.6c-.2-.1-.5-.2-.9-.2h-1.3c-1.3 0-2.4.2-3.3.5-.9.4-1.5.9-2 1.6-.9 1.4-1.4 3.2-1.3 5.4v13.3H858V67zM875.5 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.8-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.7 1.1-.9 2.8-.9 4.8zM904.1 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM927.2 75.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.6h13zM966.1 69.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6h-4.7zM973.6 61.7h4.3v-5.2l4.5-1.5v6.8h5.4v3.4h-5.4v15.1c0 .3 0 .6.1 1 0 .4.1.7.4 1.1.2.4.5.6 1 .8.4.3 1 .4 1.8.4 1 0 1.7-.1 2.2-.2V87c-.9.2-2.1.3-3.8.3-2.1 0-3.6-.4-4.6-1.2-1-.8-1.5-2.2-1.5-4.2V65.1h-4.3v-3.4zM993.5 50.9h5.5V56h-5.5v-5.1m.5 10.9h4.6v25.1H994V61.8zM1006.1 74.7c0-1.6.2-3.2.6-4.8.4-1.6 1.1-3 2-4.4 1-1.3 2.2-2.4 3.8-3.2 1.6-.8 3.6-1.2 5.9-1.2 2.4 0 4.5.4 6.1 1.3 1.5.9 2.7 2 3.6 3.3.9 1.3 1.5 2.8 1.8 4.3.2.8.3 1.5.4 2.2v2.2c0 3.7-1 6.9-3 9.5-2 2.6-5.1 4-9.3 4-4-.1-7-1.4-9-3.9-1.9-2.5-2.9-5.6-2.9-9.3m4.7-.3c0 2.7.6 5 1.8 6.9 1.2 2 3 3 5.6 3.1.9 0 1.8-.2 2.7-.5.8-.3 1.6-.9 2.3-1.7.7-.8 1.3-1.9 1.8-3.2.4-1.3.6-2.9.6-4.7-.1-6.4-2.5-9.6-7.1-9.6-.7 0-1.5.1-2.4.3-.8.3-1.7.8-2.5 1.6-.8.7-1.4 1.7-1.9 3-.6 1.1-.9 2.8-.9 4.8zM1038.6 64.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V87h-4.6V71c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V87h-4.6V64.7zM479.1 100.8h5.2l14.1 36.1h-5.3l-3.8-9.4h-16.2l-3.8 9.4h-5l14.8-36.1m-4.4 22.7H488l-6.5-17.8-6.8 17.8zM508.7 138.8c.1.7.2 1.4.4 1.9.2.6.5 1.1.9 1.6.8.9 2.3 1.4 4.4 1.5 1.6 0 2.8-.3 3.7-.9.9-.6 1.5-1.4 1.9-2.4.4-1.1.6-2.3.7-3.7.1-1.4.1-2.9.1-4.6-.5.9-1.1 1.7-1.8 2.3-.7.6-1.5 1-2.3 1.3-1.7.4-3 .6-3.9.6-1.2 0-2.4-.2-3.8-.6-1.4-.4-2.6-1.2-3.7-2.5-1-1.3-1.7-2.8-2.1-4.4-.4-1.6-.6-3.2-.6-4.8 0-4.3 1.1-7.4 3.2-9.5 2-2.1 4.6-3.1 7.6-3.1 1.3 0 2.3.1 3.2.4.9.3 1.6.6 2.1 1 .6.4 1.1.8 1.5 1.2l.9 1.2v-3.4h4.4l-.1 4.5v15.7c0 2.9-.1 5.2-.2 6.7-.2 1.6-.5 2.8-1 3.7-1.1 1.9-2.6 3.2-4.6 3.7-1.9.6-3.8.8-5.6.8-2.4 0-4.3-.3-5.6-.8-1.4-.5-2.4-1.2-3-2-.6-.8-1-1.7-1.2-2.7-.2-.9-.3-1.8-.4-2.7h4.9m5.3-5.8c1.4 0 2.5-.2 3.3-.7.8-.5 1.5-1.1 2-1.8.5-.6.9-1.4 1.2-2.5.3-1 .4-2.6.4-4.8 0-1.6-.2-2.9-.4-3.9-.3-1-.8-1.8-1.4-2.4-1.3-1.4-3-2.2-5.2-2.2-1.4 0-2.5.3-3.4 1-.9.7-1.6 1.5-2 2.4-.4 1-.7 2-.9 3-.2 1-.2 2-.2 2.8 0 1 .1 1.9.3 2.9.2 1.1.5 2.1 1 3 .5.9 1.2 1.6 2 2.2.8.7 1.9 1 3.3 1zM537.6 125.2c-.1 2.6.5 4.8 1.7 6.5 1.1 1.7 2.9 2.6 5.3 2.6 1.5 0 2.8-.4 3.9-1.3 1-.8 1.6-2.2 1.8-4h4.6c0 .6-.2 1.4-.4 2.3-.3 1-.8 2-1.7 3-.2.3-.6.6-1 1-.5.4-1 .7-1.7 1.1-.7.4-1.5.6-2.4.8-.9.3-2 .4-3.3.4-7.6-.2-11.3-4.5-11.3-12.9 0-2.5.3-4.8 1-6.8s2-3.7 3.8-5.1c1.2-.8 2.4-1.3 3.7-1.6 1.3-.2 2.2-.3 3-.3 2.7 0 4.8.6 6.3 1.6s2.5 2.3 3.1 3.9c.6 1.5 1 3.1 1.1 4.6.1 1.6.1 2.9 0 4h-17.5m12.9-3v-1.1c0-.4 0-.8-.1-1.2-.1-.9-.4-1.7-.8-2.5s-1-1.5-1.8-2.1c-.9-.5-2-.8-3.4-.8-.8 0-1.5.1-2.3.3-.8.2-1.5.7-2.2 1.3-.7.6-1.2 1.3-1.6 2.3-.4 1-.7 2.2-.8 3.7h13zM562.9 114.7l-.1-2.9h4.6v4.1c.2-.3.4-.8.7-1.2.3-.5.8-1 1.3-1.5.6-.5 1.4-1 2.3-1.3.9-.3 2-.5 3.4-.5.6 0 1.4.1 2.4.2.9.2 1.9.5 2.9 1.1 1 .6 1.8 1.4 2.5 2.5.6 1.2 1 2.7 1 4.7V137h-4.6v-16c0-.9-.1-1.7-.2-2.4-.2-.7-.5-1.3-1.1-1.9-1.2-1.1-2.6-1.7-4.3-1.7-1.7 0-3.1.6-4.3 1.8-1.3 1.2-2 3.1-2 5.7V137h-4.6v-22.3zM607 119.8c0-.3 0-.8-.1-1.4-.1-.6-.3-1.1-.6-1.8-.2-.6-.7-1.2-1.4-1.6-.7-.4-1.6-.6-2.7-.6-1.5 0-2.7.4-3.5 1.2-.9.8-1.5 1.7-1.9 2.8-.4 1.1-.6 2.2-.7 3.2-.1 1.1-.2 1.8-.1 2.4 0 1.3.1 2.5.3 3.7.2 1.2.5 2.3.9 3.3.8 2 2.4 3 4.8 3.1 1.9 0 3.3-.7 4.1-1.9.8-1.1 1.2-2.3 1.2-3.6h4.6c-.2 2.5-1.1 4.6-2.7 6.3-1.7 1.8-4.1 2.7-7.1 2.7-.9 0-2.1-.2-3.6-.6-.7-.2-1.4-.6-2.2-1-.8-.4-1.5-1-2.2-1.7-.7-.9-1.4-2.1-2-3.6-.6-1.5-.9-3.5-.9-6.1 0-2.6.4-4.8 1.1-6.6.7-1.7 1.6-3.1 2.7-4.2 1.1-1 2.3-1.8 3.6-2.2 1.3-.4 2.5-.6 3.7-.6h1.6c.6.1 1.3.2 1.9.4.7.2 1.4.5 2.1 1 .7.4 1.3 1 1.8 1.7.9 1.1 1.4 2.1 1.7 3.1.2 1 .3 1.8.3 2.6H607zM629.1 137.1l-3.4 9.3H621l3.8-9.6-10.3-25h5.2l7.6 19.8 7.7-19.8h5z"/>
#                   </svg>
#                 </span>
#               </a>
#               <button class="usa-menu-btn usa-button l-header__menu-button">Menu</button>
#             </div>
#             <div class="l-header__search">
#               <form class="usa-search usa-search--small usa-search--epa" method="get" action="https://search.epa.gov/epasearch">
#                 <div role="search">
#                   <label class="usa-sr-only" for="search-box">Search</label>
#                   <input class="usa-input" id="search-box" type="search" name="querytext" placeholder="Search EPA.gov">
#                   <!-- button class="usa-button" type="submit" --> <!-- type="submit" - removed for now to allow other unrendered buttons to render when triggered in RShiny app -->
#                   <!-- see: https://github.com/rstudio/shiny/issues/2922 -->
#                   <button class="usa-button usa-search__submit" style="height:2rem;margin:0;padding:0;padding-left:1rem;padding-right:1rem;border-top-left-radius: 0;border-bottom-left-radius: 0;">
#                     <span class="usa-sr-only">Search</span>
#                   </button>
#                   <input type="hidden" name="areaname" value="">
#                   <input type="hidden" name="areacontacts" value="">
#                   <input type="hidden" name="areasearchurl" value="">
#                   <input type="hidden" name="typeofsearch" value="epa">
#                   <input type="hidden" name="result_template" value="">
#                 </div>
#               </form>
#             </div>
#           </div>
#         </div>
#         <div class="l-header__nav">
#           <nav class="usa-nav usa-nav--epa" role="navigation" aria-label="EPA header navigation">
#             <div class="usa-nav__inner">
#               <button class="usa-nav__close" aria-label="Close">
#                 <svg class="icon icon--nav-close" aria-hidden="true" role="img">
#                   <title>Primary navigation</title>
#                   <use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#close"></use>
#                 </svg> </button>
#               <div class="usa-nav__menu">
#                  <ul class="menu menu--main">
#                   <li class="menu__item"><a href="https://www.epa.gov/environmental-topics" class="menu__link">Environmental Topics</a></li>
#                   <li class="menu__item"><a href="https://www.epa.gov/laws-regulations" class="menu__link" >Laws &amp; Regulations</a></li>
#                   <li class="menu__item"><a href="https://www.epa.gov/report-violation" class="menu__link" >Report a Violation</a></li>
#                   <li class="menu__item"><a href="https://www.epa.gov/aboutepa" class="menu__link" >About EPA</a></li>
#                 </ul>
#               </div>
#             </div>
#           </nav>
#         </div>
#       </header>
#       <main id="main" class="main" role="main" tabindex="-1">'
#     ),
#
#     # Individual Page Header
#     HTML(
#       '<div class="l-page  has-footer">
#         <div class="l-constrain">
#           <div class="l-page__header">
#             <div class="l-page__header-first">
#               <div class="web-area-title"></div>
#             </div>
#             <div class="l-page__header-last">
#               <a href="#" class="header-link">Contact Us</a>
#             </div>
#           </div>
#           <article class="article">'
#     ),
#
#     # _Insert your UI code here ----
#     # ## Begin example UI code
#     # titlePanel("Hello Shiny!"),
#     # sidebarLayout
#     # (
#     #   sidebarPanel
#     #   (
#     #     sliderInput
#     #     (
#     #       "obs",
#     #       "Number of observations:",
#     #       min = 0,
#     #       max = 1000,
#     #       value = 500
#     #     )
#     #   ),
#     #   mainPanel
#     #   (
#     #     plotOutput("distPlot")
#     #   )
#     # )
#     # ## End example UI code
#
#     # IMPORTANT! For a navbar page, you will need to place the header and footer inside the navbar section (as shown below)  -
#     # you will then want to comment out lines 201-213 and lines 254-263
#       navbarPage(
#         title = h2("Continuous data QC, summary, and statistics - v2.0.7.9007"),
#         #theme= shinytheme("spacelab"),
#         header = HTML(
#           '<div class="l-page  has-footer">
#             <div class="l-constrain">
#               <div class="l-page__header">
#                 <div class="l-page__header-first">
#                   <div class="web-area-title"></div>
#                 </div>
#                 <div class="l-page__header-last">
#                   <a href="#" class="header-link">Contact Us</a>
#                 </div>
#               </div>
#               <article class="article">'
#         ),
#         footer = HTML(
#           '</article>
#     	        </div>
#               <div class="l-page__footer">
#                 <div class="l-constrain">
#                   <p><a href="#">Contact Us</a> to ask a question, provide feedback, or report a problem.</p>
#                 </div>
#               </div>
#             </div>'
#         ),
#          tab_1Overview(),
#          tab_2FAQ(),
#          tab_3DataPrep(),
#          tab_4QCThresh(),
#          tab_5MainFunc(),
#          tab_6USGSgage(),
#          tab_7TestData(),
#          tab_8Console(),
#          #tab_9Status(),
#       ),
#
#     # Individual Page Footer
#     HTML(
#       '</article>
#       </div>
#       <div class="l-page__footer">
#         <div class="l-constrain">
#           <p><a href="#">Contact Us</a> to ask a question, provide feedback, or report a problem.</p>
#         </div>
#       </div>
#     </div>'
#     ),
#
#     # Site Footer
#     HTML(
#       '</main>
#         <footer class="footer" role="contentinfo">
#         <div class="l-constrain">
#           <img class="footer__epa-seal" src="https://www.epa.gov/themes/epa_theme/images/epa-seal.svg" alt="United States Environmental Protection Agency" height="100" width="100">
#           <div class="footer__content contextual-region">
#             <div class="footer__column">
#               <h2>Discover.</h2>
#               <ul class="menu menu--footer">
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/accessibility" class="menu__link">Accessibility</a>
#                 </li>
#                 <!--li class="menu__item"><a href="#" class="menu__link">EPA Administrator</a></li-->
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/planandbudget" class="menu__link">Budget &amp; Performance</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/contracts" class="menu__link">Contracting</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/home/wwwepagov-snapshots" class="menu__link">EPA www Web Snapshot</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/grants" class="menu__link">Grants</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/ocr/whistleblower-protections-epa-and-how-they-relate-non-disclosure-agreements-signed-epa-employees" class="menu__link">No FEAR Act Data</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/web-policies-and-procedures/plain-writing" class="menu__link">Plain Writing</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/privacy" class="menu__link">Privacy</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/privacy/privacy-and-security-notice" class="menu__link">Privacy and Security Notice</a>
#                 </li>
#               </ul>
#             </div>
#             <div class="footer__column">
#               <h2>Connect.</h2>
#               <ul class="menu menu--footer">
#                 <li class="menu__item">
#                   <a href="https://www.data.gov/" class="menu__link">Data.gov</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/office-inspector-general/about-epas-office-inspector-general" class="menu__link">Inspector General</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/careers" class="menu__link">Jobs</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/newsroom" class="menu__link">Newsroom</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/data" class="menu__link">Open Government</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.regulations.gov/" class="menu__link">Regulations.gov</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/newsroom/email-subscriptions-epa-news-releases" class="menu__link">Subscribe</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.usa.gov/" class="menu__link">USA.gov</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.whitehouse.gov/" class="menu__link">White House</a>
#                 </li>
#               </ul>
#             </div>
#             <div class="footer__column">
#               <h2>Ask.</h2>
#               <ul class="menu menu--footer">
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/home/forms/contact-epa" class="menu__link">Contact EPA</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/web-policies-and-procedures/epa-disclaimers" class="menu__link">EPA Disclaimers</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/aboutepa/epa-hotlines" class="menu__link">Hotlines</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/foia" class="menu__link">FOIA Requests</a>
#                 </li>
#                 <li class="menu__item">
#                   <a href="https://www.epa.gov/home/frequent-questions-specific-epa-programstopics" class="menu__link">Frequent Questions</a>
#                 </li>
#               </ul>
#               <h2>Follow.</h2>
#               <ul class="menu menu--social">
#                 <li class="menu__item">
#                   <a class="menu__link" aria-label="EPA’s Facebook" href="https://www.facebook.com/EPA">
#                     <!-- svg class="icon icon--social" aria-hidden="true" -->
#                     <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="facebook-square" xmlns="http://www.w3.org/2000/svg">
#                       <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#facebook-square"></use-->
#                       <path fill="currentcolor" d="M400 32H48A48 48 0 000 80v352a48 48 0 0048 48h137.25V327.69h-63V256h63v-54.64c0-62.15 37-96.48 93.67-96.48 27.14 0 55.52 4.84 55.52 4.84v61h-31.27c-30.81 0-40.42 19.12-40.42 38.73V256h68.78l-11 71.69h-57.78V480H400a48 48 0 0048-48V80a48 48 0 00-48-48z"></path>
#                     </svg>
#                     <span class="usa-tag external-link__tag" title="Exit EPA Website">
#                       <span aria-hidden="true">Exit</span>
#                       <span class="u-visually-hidden"> Exit EPA Website</span>
#                     </span>
#                   </a>
#                 </li>
#                 <li class="menu__item">
#                   <a class="menu__link" aria-label="EPA’s Twitter" href="https://twitter.com/epa">
#                     <!-- svg class="icon icon--social" aria-hidden="true" -->
#                     <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="twitter-square" xmlns="http://www.w3.org/2000/svg">
#                       <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#twitter-square"></use -->
#                       <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zm-48.9 158.8c.2 2.8.2 5.7.2 8.5 0 86.7-66 186.6-186.6 186.6-37.2 0-71.7-10.8-100.7-29.4 5.3.6 10.4.8 15.8.8 30.7 0 58.9-10.4 81.4-28-28.8-.6-53-19.5-61.3-45.5 10.1 1.5 19.2 1.5 29.6-1.2-30-6.1-52.5-32.5-52.5-64.4v-.8c8.7 4.9 18.9 7.9 29.6 8.3a65.447 65.447 0 01-29.2-54.6c0-12.2 3.2-23.4 8.9-33.1 32.3 39.8 80.8 65.8 135.2 68.6-9.3-44.5 24-80.6 64-80.6 18.9 0 35.9 7.9 47.9 20.7 14.8-2.8 29-8.3 41.6-15.8-4.9 15.2-15.2 28-28.8 36.1 13.2-1.4 26-5.1 37.8-10.2-8.9 13.1-20.1 24.7-32.9 34z"></path>
#                     </svg>
#                     <span class="usa-tag external-link__tag" title="Exit EPA Website">
#                       <span aria-hidden="true">Exit</span>
#                       <span class="u-visually-hidden"> Exit EPA Website</span>
#                     </span>
#                   </a>
#                 </li>
#                 <li class="menu__item">
#                   <a class="menu__link" aria-label="EPA’s Youtube" href="https://www.youtube.com/user/USEPAgov">
#                     <!-- svg class="icon icon--social" aria-hidden="true" -->
#                     <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="youtube-square" xmlns="http://www.w3.org/2000/svg">
#                       <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#youtube-square"></use -->
#                       <path fill="currentcolor" d="M186.8 202.1l95.2 54.1-95.2 54.1V202.1zM448 80v352c0 26.5-21.5 48-48 48H48c-26.5 0-48-21.5-48-48V80c0-26.5 21.5-48 48-48h352c26.5 0 48 21.5 48 48zm-42 176.3s0-59.6-7.6-88.2c-4.2-15.8-16.5-28.2-32.2-32.4C337.9 128 224 128 224 128s-113.9 0-142.2 7.7c-15.7 4.2-28 16.6-32.2 32.4-7.6 28.5-7.6 88.2-7.6 88.2s0 59.6 7.6 88.2c4.2 15.8 16.5 27.7 32.2 31.9C110.1 384 224 384 224 384s113.9 0 142.2-7.7c15.7-4.2 28-16.1 32.2-31.9 7.6-28.5 7.6-88.1 7.6-88.1z"></path>
#                     </svg>
#                     <span class="usa-tag external-link__tag" title="Exit EPA Website">
#                       <span aria-hidden="true">Exit</span>
#                       <span class="u-visually-hidden"> Exit EPA Website</span>
#                     </span>
#                   </a>
#                 </li>
#                 <li class="menu__item">
#                   <a class="menu__link" aria-label="EPA’s Flickr" href="https://www.flickr.com/photos/usepagov">
#                     <!-- svg class="icon icon--social" aria-hidden="true" -->
#                     <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="flickr-square" xmlns="http://www.w3.org/2000/svg">
#                       <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#flickr-square"></use -->
#                       <path fill="currentcolor" d="M400 32H48C21.5 32 0 53.5 0 80v352c0 26.5 21.5 48 48 48h352c26.5 0 48-21.5 48-48V80c0-26.5-21.5-48-48-48zM144.5 319c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5zm159 0c-35.1 0-63.5-28.4-63.5-63.5s28.4-63.5 63.5-63.5 63.5 28.4 63.5 63.5-28.4 63.5-63.5 63.5z"></path>
#                     </svg>
#                     <span class="usa-tag external-link__tag" title="Exit EPA Website">
#                       <span aria-hidden="true">Exit</span>
#                       <span class="u-visually-hidden"> Exit EPA Website</span>
#                     </span>
#                   </a>
#                 </li>
#                 <li class="menu__item">
#                   <a class="menu__link" aria-label="EPA’s Instagram" href="https://www.instagram.com/epagov">
#                     <!-- svg class="icon icon--social" aria-hidden="true" -->
#                     <svg class="icon icon--social" aria-hidden="true" viewBox="0 0 448 512" id="instagram-square" xmlns="http://www.w3.org/2000/svg">
#                       <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#instagram-square"></use -->
#                       <path fill="currentcolor" xmlns="http://www.w3.org/2000/svg" d="M224 202.66A53.34 53.34 0 10277.36 256 53.38 53.38 0 00224 202.66zm124.71-41a54 54 0 00-30.41-30.41c-21-8.29-71-6.43-94.3-6.43s-73.25-1.93-94.31 6.43a54 54 0 00-30.41 30.41c-8.28 21-6.43 71.05-6.43 94.33s-1.85 73.27 6.47 94.34a54 54 0 0030.41 30.41c21 8.29 71 6.43 94.31 6.43s73.24 1.93 94.3-6.43a54 54 0 0030.41-30.41c8.35-21 6.43-71.05 6.43-94.33s1.92-73.26-6.43-94.33zM224 338a82 82 0 1182-82 81.9 81.9 0 01-82 82zm85.38-148.3a19.14 19.14 0 1119.13-19.14 19.1 19.1 0 01-19.09 19.18zM400 32H48A48 48 0 000 80v352a48 48 0 0048 48h352a48 48 0 0048-48V80a48 48 0 00-48-48zm-17.12 290c-1.29 25.63-7.14 48.34-25.85 67s-41.4 24.63-67 25.85c-26.41 1.49-105.59 1.49-132 0-25.63-1.29-48.26-7.15-67-25.85s-24.63-41.42-25.85-67c-1.49-26.42-1.49-105.61 0-132 1.29-25.63 7.07-48.34 25.85-67s41.47-24.56 67-25.78c26.41-1.49 105.59-1.49 132 0 25.63 1.29 48.33 7.15 67 25.85s24.63 41.42 25.85 67.05c1.49 26.32 1.49 105.44 0 131.88z"></path>
#                     </svg>
#                     <span class="usa-tag external-link__tag" title="Exit EPA Website">
#                       <span aria-hidden="true">Exit</span>
#                       <span class="u-visually-hidden"> Exit EPA Website</span>
#                     </span>
#                   </a>
#                 </li>
#               </ul>
#               <p class="footer__last-updated">
#                 Last updated on September 15, 2022
#               </p>
#             </div>
#           </div>
#         </div>
#       </footer>
#       <a href="#" class="back-to-top" title="">
#         <svg class="back-to-top__icon" role="img" aria-label="">
#         <svg class="back-to-top__icon" role="img" aria-label="" viewBox="0 0 19 12" id="arrow" xmlns="http://www.w3.org/2000/svg">
#           <!-- use xlink:href="https://www.epa.gov/themes/epa_theme/images/sprite.artifact.svg#arrow"></use -->
#           <path fill="currentColor" d="M2.3 12l7.5-7.5 7.5 7.5 2.3-2.3L9.9 0 .2 9.7 2.5 12z"></path>
#         </svg>
#       </a>'
#     )
#   ) # END fluidPage
# )## shinyUI

