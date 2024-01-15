--Cleaning Data with SQL
Select *
From PortafolioProject.dbo.NashvilleHousing

--Standarize Date format (change it)
Select SaleDateConverted, CONVERT(date,saledate)
From PortafolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = Convert (date, saledate)

Alter Table NashvilleHousing
add SaleDateConverted Date; 
update NashvilleHousing
set SaleDateConverted = Convert (date, saledate)

--Populate Property Address Data
Select* --PropertyAddress
From PortafolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
Order by ParcelID

Select A.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortafolioProject.dbo.NashvilleHousing a
Join PortafolioProject. dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is Null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortafolioProject.dbo.NashvilleHousing a
Join PortafolioProject. dbo.NashvilleHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
Where a.PropertyAddress is Null

--Breaking out Address into Individual Colums (Addres, City, State)
Select PropertyAddress
From PortafolioProject.dbo.NashvilleHousing

Select
SUBSTRING(PropertyAddress,1,CHARINDEX (',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX (',',PropertyAddress)+1,Len(PropertyAddress)) as Address

From PortafolioProject.dbo.NashvilleHousing

--Creating two new columns

Alter Table NashvilleHousing
add PropertySplitAddres Nvarchar(255); 

update NashvilleHousing
set PropertySplitAddres = SUBSTRING(PropertyAddress,1,CHARINDEX (',',PropertyAddress)-1) 

Alter Table NashvilleHousing
add PropertyCity Nvarchar(255);  

update NashvilleHousing
set PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX (',',PropertyAddress)+1,Len(PropertyAddress)) 

Select *
From PortafolioProject.dbo.NashvilleHousing


--Second method
Select OwnerAddress
From PortafolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
From PortafolioProject.dbo.NashvilleHousing

Alter Table NashvilleHousing
add OwnerSplitAddres Nvarchar(255); 

update NashvilleHousing
set OwnerSplitAddres = PARSENAME(Replace(OwnerAddress,',','.'),3)
--
Alter Table NashvilleHousing
add OwnerSplitCity Nvarchar(255);  

update NashvilleHousing
set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)
--
Alter Table NashvilleHousing
add OwnerSplitState Nvarchar(255); 

update NashvilleHousing
set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)


Select *
From PortafolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" Field

Select Distinct(SoldAsVacant), count(SoldAsVacant)
From PortafolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant
, Case when(SoldAsVacant) ='Y' Then 'Yes'
       when (SoldAsVacant)='N' Then 'No'
	   Else (SoldAsVacant)
	   End
From PortafolioProject.dbo.NashvilleHousing


Update NashvilleHousing
Set SoldAsVacant = Case when(SoldAsVacant) ='Y' Then 'Yes'
       when (SoldAsVacant)='N' Then 'No'
	   Else (SoldAsVacant)
	   End
From PortafolioProject.dbo.NashvilleHousing

--Remove Duplicates

WITH RowNumCTE AS(
Select *,
  ROW_NUMBER() Over(
  Partition by ParcelID,
			   PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   Order By
			    UniqueID
				) row_num
From PortafolioProject.dbo.NashvilleHousing
)

Select *
From RowNumCTE
WHERE row_num >1
Order by PropertyAddress



-- Delete Columns

Select *
From PortafolioProject.dbo.NashvilleHousing

Alter Table PortafolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table PortafolioProject.dbo.NashvilleHousing
Drop Column SaleDate