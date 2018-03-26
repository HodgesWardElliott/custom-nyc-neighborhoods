

download.file("http://data.beta.nyc//dataset/0ff93d2d-90ba-457c-9f7e-39e47bf2ac5f/resource/35dd04fb-81b3-479b-a074-a27a37888ce7/download/d085e2f8d0b54d4590b1e7d1f35594c1pediacitiesnycneighborhoods.geojson"
              , destfile = "pediacititis-nyc.geojson")

pedia <- read_sf("pediacititis-nyc.geojson")

# E_williamsburg <- editMap()
st_write(E_williamsburg, "east_wburg.geojson", delete_dsn = TRUE)

# Ham_Heights <- editMap()
st_write(Ham_Heights, "ham_heights.geojson", delete_dsn = TRUE)


old_williamsburg <- pedia %>% filter(neighborhood=="Williamsburg")
new_williamsburg <- st_difference(old_williamsburg, E_williamsburg$geometry) %>% st_sf() 

old_harlem <- pedia %>% filter(neighborhood=="Harlem")
new_harlem <- st_difference(old_harlem, Ham_Heights) %>% st_sf() 


new_hoods <- 
  E_williamsburg %>% 
  select(-X_leaflet_id, -feature_type) %>% 
  mutate("neighborhood" = "East Williamsburg"
         , boroughCode = "3"
         , borough = "Brooklyn"
         , X.id = NA) %>% 
  
  rbind(Ham_Heights %>% 
          select(-X_leaflet_id, -feature_type) %>% 
          mutate("neighborhood" = "Hamilton Heights"
                 , boroughCode = "1"
                 , borough = "Manhattan"
                 , X.id = NA)
  ) %>% 
  
  rbind(new_williamsburg %>% 
          mutate("neighborhood" = "Williamsburg"
                 , boroughCode = "3"
                 , borough = "Brooklyn"
                 , X.id = NA)
  ) %>% 
  rbind(new_harlem %>% 
          select(-X_leaflet_id, -feature_type) %>% 
          mutate("neighborhood" = "Harlem"
                 , boroughCode = "1"
                 , borough = "Manhattan"
                 , X.id = NA)
  )

plot(new_hoods$geometry)
