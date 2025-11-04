## PRACTICAL 1 - Implementation of PHP Application with MYSQL as back-end.

---

### **1️⃣ connection.php**

```php
<?php
$dbhost = "localhost";
$dbuser = "root";
$dbpass = "";
$dbname = "login";

if(!$con = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname)) {
    die("failed to connect!");
}
?>
```

---

### **2️⃣ functions.php**

```php
<?php
function check_login($con) {
    if(isset($_SESSION['user_id'])) {
        $id = $_SESSION['user_id'];
        $query = "select * from users where user_id = '$id' limit 1";
        $result = mysqli_query($con, $query);
        if($result && mysqli_num_rows($result) > 0) {
            $user_data = mysqli_fetch_assoc($result);
            return $user_data;
        }
    }
    // redirect to login
    header("Location: login.php");
    die;
}

function random_num($length) {
    $text = "";
    if($length < 5) {
        $length = 5;
    }
    $len = rand(4, $length);
    for ($i = 0; $i < $len; $i++) {
        $text .= rand(0, 9);
    }
    return $text;
}
?>
```

---

### **3️⃣ index.php**

```php
<?php
session_start();
include("connection.php");
include("functions.php");
$user_data = check_login($con);
?>
<!DOCTYPE html>
<html>
<head>
    <title>Lab: 1</title>
</head>
<body>
    <a href="logout.php">Logout</a>
    <h1>Welcome</h1>
    <br>
    Hello, <?php echo $user_data['user_name']; ?>
</body>
</html>
```

---

### **4️⃣ login.php**

```php
<?php
session_start();
include("connection.php");
include("functions.php");

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $user_name = $_POST['user_name'];
    $password = $_POST['password'];

    if(!empty($user_name) && !empty($password) && !is_numeric($user_name)) {
        $query = "select * from users where user_name = '$user_name' limit 1";
        $result = mysqli_query($con, $query);

        if($result && mysqli_num_rows($result) > 0) {
            $user_data = mysqli_fetch_assoc($result);
            if($user_data['password'] === $password) {
                $_SESSION['user_id'] = $user_data['user_id'];
                header("Location: index.php");
                die;
            }
        }
        echo "wrong username or password!";
    } else {
        echo "wrong username or password!";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<style type="text/css">
#text {
    height: 25px;
    border-radius: 5px;
    padding: 4px;
    border: solid thin #aaa;
    width: 100%;
}
#button {
    padding: 10px;
    width: 100px;
    color: white;
    background-color: lightblue;
    border: none;
}
#box {
    background-color: grey;
    margin: auto;
    width: 300px;
    padding: 20px;
}
</style>

<div id="box">
<form method="post">
    <div style="font-size: 20px; margin: 20px; color: white;">Login</div>
    Username<input id="text" type="text" name="user_name"><br><br>
    Password<input id="text" type="password" name="password"><br><br>
    <input id="button" type="submit" value="Login"><br><br>
    <a href="signup.php">Click to Signup</a><br><br>
</form>
</div>
</body>
</html>
```

---

### **5️⃣ signup.php**

```php
<?php
session_start();
include("connection.php");
include("functions.php");

if($_SERVER['REQUEST_METHOD'] == "POST") {
    $user_name = $_POST['user_name'];
    $password = $_POST['password'];

    if(!empty($user_name) && !empty($password) && !is_numeric($user_name)) {
        $user_id = random_num(20);
        $query = "insert into users (user_id, user_name, password) values ('$user_id', '$user_name', '$password')";
        mysqli_query($con, $query);
        header("Location: login.php");
        die;
    } else {
        echo "Please enter some valid information!";
    }
}
?>
<!DOCTYPE html>
<html>
<head>
    <title>Signup</title>
</head>
<body>
<style type="text/css">
#text {
    height: 25px;
    border-radius: 5px;
    padding: 4px;
    border: solid thin #aaa;
    width: 100%;
}
#button {
    padding: 10px;
    width: 100px;
    color: white;
    background-color: lightblue;
    border: none;
}
#box {
    background-color: grey;
    margin: auto;
    width: 300px;
    padding: 20px;
}
</style>

<div id="box">
<form method="post">
    <div style="font-size: 20px; margin: 10px; color: white;">Signup</div>
    Username<input id="text" type="text" name="user_name"><br><br>
    Password<input id="text" type="password" name="password"><br><br>
    <input id="button" type="submit" value="Signup"><br><br>
    <a href="login.php">Click to Login</a><br><br>
</form>
</div>
</body>
</html>
```

---

### **6️⃣ logout.php**

```php
<?php
session_start();
if(isset($_SESSION['user_id'])) {
    unset($_SESSION['user_id']);
}
header("Location: login.php");
die;
?>
```
---
---

## PRACTICAL 2

---

###  **prac2_atl.py**

```python
# Import libraries
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# Read data
data = pd.read_csv("heart.csv")
data.head()

# Check number of rows and columns
print(data.shape)

# Dataset information
data.info()

# Descriptive statistics
print(data.describe())

# Observations:
# 1) Average age is 54 years and minimum is 29 years — no children in this data.
# 2) Average resting BP is 131, maximum 200.
# 3) Average cholesterol is 246, maximum 564 (possible outlier).
# 4) Average heart rate is 149, maximum 200 (questionable).

# Check missing values
print(data.isnull().any())

# Analyze gender vs heart attack (output = 1)
sum_target = data['output'].sum()
data_sex = pd.pivot_table(
    data=data[data['output'] == 1],
    index='sex',
    values='output',
    aggfunc='count'
).reset_index()

data_sex['percentage'] = (data_sex['output'] * 100) / sum_target

# Visualization
colors = ['lightslategrey', 'brown']
fig = plt.figure(figsize=(10, 7))
gs = fig.add_gridspec(1, 2)
ax0 = fig.add_subplot(gs[0, 0])
ax1 = fig.add_subplot(gs[0, 1])
axes = [ax0, ax1]

background_color = '#f6f5f7'
for i in axes:
    i.set_facecolor(background_color)
    i.spines["bottom"].set_visible(False)
    i.spines["left"].set_visible(False)
    i.set_xlabel("")
    i.set_ylabel("")
    i.set_xticklabels([])
    i.set_yticklabels([])

fig.patch.set_facecolor(background_color)

labels = data_sex['sex']
values = data_sex['percentage']

ax0.pie(values, labels=labels, colors=colors, autopct='%1.1f%%', shadow=True, startangle=90)
ax1.text(
    0.5, 0.5,
    '56.4% of male population had heart attack\nand 43.6% of female had heart attack',
    horizontalalignment='center',
    verticalalignment='center',
    fontsize=12,
    fontfamily='serif'
)

plt.text(-1.4, 0.9, 'Heart attacks % of male and female', fontsize=18, fontweight='bold', fontfamily='serif')

for i in ["top", "right", "bottom", "left"]:
    ax1.spines[i].set_visible(False)
ax1.tick_params(left=False, bottom=False)

plt.show()
```

---
---

## PRACTICAL 3 - Implementation of web Application using R.

### 🧠 **prac3_atl.R**

```r
# Load libraries
library(shiny)
library(dplyr)
library(vroom)

# Read data
sales <- vroom::vroom("saledata.csv", na = "")

# UI definition
ui <- fluidPage(
  titlePanel("Dashboard for Sales Data"),
  sidebarLayout(
    sidebarPanel(
      selectInput("territories", "Territories", choices = unique(sales$territories)),
      selectInput("Customers", "Customer", choices = sales$Customers)
    ),
    mainPanel(
      uiOutput("customer"),
      tableOutput("data")
    )
  )
)

# Server logic
server <- function(input, output, session) {

  territories <- reactive({
    req(input$territories)
    filter(sales, territories == input$territories)
  })

  customer <- reactive({
    req(input$Customers)
    filter(territories(), Customers == input$Customers)
  })

  output$customer <- renderUI({
    row <- customer()[1, ]
    tags$div(
      class = "well",
      tags$p(tags$strong("Name: "), row$fname, " ", row$lname),
      tags$p(tags$strong("Phone: "), row$contact),
      tags$p(tags$strong("Order: "), row$order)
    )
  })

  order <- reactive({
    req(input$order)
    customer() %>%
      filter(order == input$order) %>%
      arrange(OLNUMBER) %>%
      select(pline, qty, price, sales, status)
  })

  output$data <- renderTable(order())

  observeEvent(territories(), {
    updateSelectInput(
      session, "Customers",
      choices = unique(territories()$Customers),
      selected = character()
    )
  })

  observeEvent(customer(), {
    updateSelectInput(
      session, "order",
      choices = unique(customer()$order)
    )
  })
}

# Run the Shiny app
shinyApp(ui, server)
```

---
