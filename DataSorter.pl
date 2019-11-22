##################################################################
#                                                                #
#       Written By: Kevin Wang                                   #
#       Goal: Find certain data for video game sales             #
#                                                                #
#       Methods used: In order to sort the data, I utilized      #
#       Perls hash. Hash utilizes keys and values which I        #
#       was able to utilize. I used the 'Ranks' column as my     #
#       key and stored the values. For me to actually access     #
#       specific values of a key, I used a loop to go through    #
#       each key and dereferenced the hash by instantiating an   #
#       array to the specific record of the hash. After that     #
#       contains a nested loop going through each element of the #
#       array or the 'values' of the specific key. If the data   #
#       I had needed was specific to the year, I would find the  #
#       first year that matches the given year then created a    #
#       variable 'skip' to not run the loop more than once.      #
#       After the first nested loop sequence is completed, it    #
#       compares the values we had stored to the next keys in the#
#       hash. It is important that the 'skip' was instantiated   #
#       outside of the loop so it does not reset to our static   #
#       value which default is 0.                                #
#                                                                #
#       Modules used:                                            #
#              Text:CSV to read the Excel file                   #
#              Spreadsheet::WriteExcel to write to Excel file    #
#                                                                #
##################################################################


use Text::CSV;
use Term::Menus;
use Term::ANSIColor qw(:constants);
use Switch;

my %games = ();
my $counter = 1;
my $csv = Text::CSV->new ({binary=>1}) ;
$file = "vgsales.csv" ;
if(!open($fh, "<", $file )) {
  # Cannot call getline is a symptom of a bad open() 
  printf("### Error %s: could not open file %s\n", $ws, $file) ;
  close($fh) ;
  exit 1 ; 
}


while(my $row = $csv->getline($fh)) {
  @items = @{$row};
  for(my $i=0 ; $i<=$#items; $i++) {
    if(($i % 7) == 6){ #On the last value, insert value then increment counter for key
        push @{$games{$counter}}, $items[$i];
        $counter = $counter + 1;
    }elsif($i != 0){ #Skip the ranking as thats our key and insert values
        push @{$games{$counter}}, $items[$i];
    }
  }
}


my $esc = 0;
do {
my @list=('Top sales by Platform, Year, Genre and Publisher',
'Top sales by Platform given the year',
'Top sales by Genre given the year',
'Top sales by Publisher given the year',
'Game with the lowest sales',
'Game with the highest sales',
'Platform with the lowest sales',
'Platform with the highest sales',
'Publisher with the lowest sales',
'Publisher with the highest sales',
'Year with highest sales',
'Year with the lowest sales',
'EXIT');
my $banner="  Please Pick an Item:";
my $selection=&pick(\@list,$banner);
print "SELECTION = $selection\n";

	switch($selection){
	case("Top sales by Platform, Year, Genre and Publisher"){ 
        topOverall();  
    }
    case("Top sales by Platform given the year"){ 
        topYearPlatform(); 
    }
    case("Top sales by Genre given the year"){ 
        topYearGenre();
    }
    case("Top sales by Publisher given the year"){ 
        topYearPublisher();
    }
    case("Game with the lowest sales"){ 
        lowGameSales();
    }
    case("Game with the highest sales"){ 
        highGameSales();
    }
    case("Platform with the lowest sales"){ 
        lowPlatform(); 
    }
    case("Platform with the highest sales"){ 
        topPlatform();  
    }
    case("Publisher with the lowest sales"){
        lowPublisher(); 
    }
    case("Publisher with the highest sales"){
        topPublisher(); 
    }
    case("Year with highest sales"){ 
        highSales(); 
    }
    case("Year with the lowest sale"){ 
        lowSales(); 
    }case("EXIT"){
        $esc = 1;
    }
	}

}while($esc != 1);
#Top overall
sub topOverall{
my $year;
my $highestPrice;
my $gameName;
my $pub;
my $plat;
my $genre;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
                $gameName = $array[0];
                $plat = $array[1];
                $year = $array[2];
                $genre = $array[3];
                $pub = $array[4];
            }
            elsif($array[5] > $highestPrice){
                $highestPrice = $array[5]; 
                $gameName = $array[0];
                $plat = $array[1];
                $year = $array[2];
                $genre = $array[3];
                $pub = $array[4];
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The publisher with the highest sales is $pub, on $plat, releasing the game $gameName that is in genre $genre \n", RESET;
    print GREEN, "in $year with $highestPrice million in sales\n", RESET;
    } else {
        print GREEN, "No games found", RESET;
    }
}

#Top platform given the year
sub topYearPlatform{
print "Enter a year: ";
my $year = <STDIN>;
my $highestPrice;
my $plat;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($array[2] == $year && $skip == 0){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
                $plat = $array[1];                
                $skip = $skip + 1;
            }
            elsif($array[2] == $year){ #Make the year equal to the year we want to find
                if($array[5] > $highestPrice){ #If the sales is higher than our current highest price, replace
                    $highestPrice = $array[5]; 
                    $plat = $array[1];                
                }
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The platform with the highest sales is $plat in $year\n", RESET;
    } else {
        print GREEN, "No sales found", RESET;
    }
}

#Top sales by Platform 
sub topPlatform{
my $highestPrice;
my $plat;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($array[2] == $year && $skip == 0){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
                $plat = $array[1];
                $skip = $skip + 1;
            }
            elsif($array[2] == $year){ #Make the year equal to the year we want to find
                if($array[5] > $highestPrice){ #If the sales is higher than our current highest price, replace
                    $highestPrice = $array[5]; 
                    $plat = $array[1];
                }
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The platform with the highest sales is $plat\n", RESET;
    } else {
        print GREEN, "No platforms found", RESET;
    }
}
sub lowPlatform{
my $lowestPrice;
my $gameName;
my $plat;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $lowestPrice = $array[5]; 
                $plat = $array[1];

            }
            elsif($array[5] < $lowestPrice){
                $lowestPrice = $array[5];
                $plat = $array[1];
            }
        }
    }
    if($lowestPrice != 0){
    print GREEN, "The platform with the lowest sales is $plat\n", RESET;
    } else {
        print GREEN, "No platforms found", RESET;
    }
}
#Top sales by Genre
sub topGenre{
my $highestPrice;
my $genre;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $highestPrice = $array[5]; 
                $genre = $array[3];

            }
            elsif($array[5] > $highestPrice){
                $highestPrice = $array[5];
                $genre = $array[3];
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The genre with the highest sales is $genre\n", RESET;
    } else {
        print GREEN, "No games found", RESET;
    }
}

sub topYearGenre{
print "Enter a year: ";
my $year = <STDIN>;
my $highestPrice;
my $genre;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($array[2] == $year && $skip == 0){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
                $genre = $array[3];
                $skip = $skip + 1;
            }
            elsif($array[2] == $year){ #Make the year equal to the year we want to find
                if($array[5] > $highestPrice){ #If the sales is higher than our current highest price, replace
                    $highestPrice = $array[5]; 
                $genre = $array[3];
                }
            }
        }
    }
    if($highestPrice != 0){
        print GREEN, "The genre with the highest sales is $genre in $year\n", RESET;
    } else {
        print GREEN, "No sales found", RESET;
    }
}

#Top sales by Publisher given the year - User gives year, collect all games in that year, return the highest sale
sub topYearPublisher{
print "Enter a year: ";
my $year = <STDIN>;
my $highestPrice;
my $gameName;
my $pub;
my $skip = 0;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($array[2] == $year && $skip == 0){ #Make the first year found the highest price
                $highestPrice = $array[5]; 
                $gameName = $array[0];
                $pub = $array[4];
                $skip = $skip + 1;
            }
            elsif($array[2] == $year){ #Make the year equal to the year we want to find
                if($array[5] > $highestPrice){ #If the sales is higher than our current highest price, replace
                    $highestPrice = $array[5]; 
                    $gameName = $array[0];
                    $pub = $array[4];
                }
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The publisher with the highest sales is $pub, releasing the game $gameName in $year with $highestPrice million in sales\n", RESET;
    } else {
        print GREEN, "No games found", RESET;
    }
}

sub lowPublisher{
my $lowestPrice;
my $pub;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $lowestPrice = $array[5]; 
                $pub = $array[4];

            }
            elsif($array[5] < $lowestPrice){
                $lowestPrice = $array[5];
                $pub = $array[4];
            }
        }
    }
    if($lowestPrice != 0){
    print GREEN, "The publisher with the lowest sales is $pub\n", RESET;
    } else {
        print GREEN, "No games found", RESET;
    }
}

sub highPublisher{
my $highestPrice;
my $pub;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
                $pub = $array[4];

            }
            elsif($array[5] > $highestPrice){
                $highestPrice = $array[5];
                $pub = $array[4];
            }
        }
    }
    if($highestPrice != 0){
    print GREEN, "The publisher with the highest sales is $pub\n", RESET;
    } else {
        print GREEN, "No games found", RESET;
    }
}

sub lowGameSales{
my $lowestPrice;
my $gameName;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $lowestPrice = $array[5]; 
                $gameName = $array[0];
            }
            elsif($array[5] < $lowestPrice){
                $lowestPrice = $array[5];
                $gameName = $array[0];
            }
        }
    }

    print GREEN, "The game with the lowest sales is $gameName.\n", RESET;
}
sub highGameSales{
my $highestPrice;
my $gameName;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $highestPrice = $array[5]; 
                $gameName = $array[0];
            }
            elsif($array[5] > $highestPrice){
                $highestPrice = $array[5];
                $gameName = $array[0];
            }
        }
    }

    print GREEN, "The game with the lowest sales is $gameName.\n", RESET;
}
#Game with the lowest sales - Return last rank
sub lowSales{
my $lowestPrice;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the lowest price
                $lowestPrice = $array[5]; 
                $gameName = $array[0];
            }
            elsif($array[5] < $lowestPrice){
                $lowestPrice = $array[5];
                $gameName = $array[0];
            }
        }
    }

    print GREEN, "The game with the lowest sales is $lowestPrice million in sales.\n", RESET;
}
#Game with the highest sales - Return rank 1
sub highSales{
my $highestPrice;
    foreach my $key (sort keys %games) {
        my @array = @{ $games{$key} };    #Dereference
        foreach my $element (@array) {                 #Much easier to read and understand
            if($key == 1){ #Make the first hash the highest price
                $highestPrice = $array[5]; 
            }
            elsif($array[5] > $highestPrice){
                $highestPrice = $array[5];
            }
        }
    }

    print GREEN, "The game with the highest sales is $highestPrice million in sales\n", RESET;
}
