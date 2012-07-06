import stdlib.web.client
module View {
  function pageWrapper(title, content) {
    Resource.full_page(
      title,
      content,
      <meta name="viewport" content="width=device-width, initial-scale=1.0 , maximum-scale=1.0"/>
      ,
      web_response {success},
      {nil}
      );
  }
  function template(content) {
    <div class="navbar">
      <div class="navbar-inner">
        <div class="container">
          <a class="brand span2" href="/main">Cactus DB</a>
          <span class="nav-collapse collapse">
            <span class="form-search pull-right" style="text-align: right">
              <input id=#searchtext type="text" class="input-medium search-query" />
              <input type="button" class="btn btn-info" value="locate" onclick={function(_) {findPlant()}} />
            </>
            <ul class="nav">
              <li><a href="/main">Main</a></li>
              <li><a href="/aging">Aging Report</a></li>
              <li><a href="/meta">Meta</a></li>
            </ul>
          </>
          
        </>
      </>
    </>
    <div id=#main class="container-fluid">
      <div class="row-fluid">     
        {content} 
      </div>
      <hr>
      <footer>
        <p>Cactus DB</p>
      </footer>
    </div>
  }

  function page(path) {
    
    content = 
      <div class="">
        Eggs brah <br />
        {path}
      </>
    template(content)
  }
  
  
  function meta(path) {

    content = 
      <div id=#meta_root>
      <h1>Meta Data: {path}</h1>
      <h2>Families</>
      <ul id=#meta_family_list>
      {
        Iter.map(function(a) {
            <li id={"meta_family_{a.id}"}> {
            Meta.meta_family(a)
            }</li>
          }, Model.get_plant_families())
      }
      </ul>
      {Meta.meta_form_family()}<br />
      <hr />

      <h1>Events</h1>
      <ul id=#meta_event_kind_list>
      {
        Iter.map(function(a) {
            <li id={"meta_event_kind_{a.kind}"}> {
            Meta.meta_event_kind(a)
            }</li>
          }, Model.get_event_kinds())
      }
      </ul>
      {Meta.meta_form_event_kind()}<br />
      </>

    template(content)
  }
  function aging(path) {

    content = 
      <div>
      Aging: {path}
      </>
    template(content)
  }
  function find(path) {

    content = 
      <div>
      Find: {path}
      </>
    template(content)
  }
  function plant(path) {
    content = 
      <div>
      Plant: {path}
      </>
    template(content)
  }


  function findPlant() {
    searchtext = Dom.get_value(#searchtext)
    Dom.clear_value(#searchtext)
    search_type = parser {
      case [0-9]+ "-" [0-9]+ "-" [0-9]+ : {fullDisplayId}
      case [0-9]+ "-" [0-9]+ : {speciesVariantAll}
      case [0-9]+ : {speciesAll}
      case (.*) : {other}
    }
    st = Parser.parse(search_type,searchtext)
    match(st) {
      case {fullDisplayId} : Client.goto("/plant/" ^ searchtext)
      case {speciesVariantAll} : Client.goto("/find/plants/" ^ searchtext)
      case {speciesAll} : Client.goto("/find/plants/" ^ searchtext)
      case {other} : Client.goto("/find/all/" ^ searchtext)
    }

    void
  }
}

