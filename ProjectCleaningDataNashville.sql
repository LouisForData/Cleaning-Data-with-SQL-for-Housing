/*

Cleaning Data in SQL Queries 

*/

Select *
From MyPortfolioProject..

------------------------------------------------------------------------------

--Standardize Date Format

Select SaleDate, Convert(Date,SaleDate)
From MyPortfolioProject..NashvilleHousing



Select SaleDateConverted , Convert(Date,SaleDate)
From MyPortfolioProject..NashvilleHousing

--update NashvilleHousing
--SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; 

update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--------------------------------------------------------------------------------
--Populate Property Address data

Select PropertyAddress
From MyPortfolioProject..NashvilleHousing
---Where PropertyAddress is Null
order by ParcelID

Select PropertyAddress
From MyPortfolioProject..NashvilleHousing
---Where PropertyAddress is Null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From MyPortfolioProject..NashvilleHousing a
Join MyPortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress  is Null




Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From MyPortfolioProject..NashvilleHousing a
Join MyPortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress  is Null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From MyPortfolioProject..NashvilleHousing a
Join MyPortfolioProject..NashvilleHousing b
    ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress  is Null


------------------------------------------------------------------------------------
--Breaking out Address into individual Columns(Address, city, State)

Select PropertyAddress
From MyPortfolioProject..NashvilleHousing

--Step 1
SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',', PropertyAddress)) as Address
From MyPortfolioProject..NashvilleHousing

--Step 2
--looking at Chart Index 
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
CHARINDEX(',', PropertyAddress)
From MyPortfolioProject..NashvilleHousing

--Step 3

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
From MyPortfolioProject..NashvilleHousing

--Step 4
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
From MyPortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress Nvarchar(255); 

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity  Nvarchar(255); 

update NashvilleHousing
SET PropertySplitCity =SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select *
From MyPortfolioProject..NashvilleHousing


-------------------------------------------------------




Select * 
From MyPortfolioProject..NashvilleHousing

Select OwnerAddress
From MyPortfolioProject..NashvilleHousing
Where OwnerAddress is not Null 



--It separates back wards


Select

PARSENAME(Replace(OwnerAddress, ',' , '.'), 1),
PARSENAME(Replace(OwnerAddress, ',' , '.'), 2),
PARSENAME(Replace(OwnerAddress, ',' , '.'), 3)

From MyPortfolioProject..NashvilleHousing

Where OwnerAddress is not Null


--Separate the right way 


Select

PARSENAME(Replace(OwnerAddress, ',' , '.'), 3),
PARSENAME(Replace(OwnerAddress, ',' , '.'), 2),
PARSENAME(Replace(OwnerAddress, ',' , '.'), 1)

From MyPortfolioProject..NashvilleHousing

Where OwnerAddress is not Null

--Adding coolumns and values 

--Address

ALTER TABLE NashvilleHousing
ADD OwnersSplitAddress Nvarchar(255); 

update NashvilleHousing
SET OwnersSplitAddress =  PARSENAME(Replace(OwnerAddress, ',' , '.'), 3)

---City

ALTER TABLE NashvilleHousing
ADD OwnersSplitCity  Nvarchar(255); 

update NashvilleHousing
SET OwnersSplitCity  = PARSENAME(Replace(OwnerAddress, ',' , '.'), 2) 

--State

ALTER TABLE NashvilleHousing
ADD OwnersSplitState  Nvarchar(255); 

update NashvilleHousing
SET OwnersSplitState  = PARSENAME(Replace(OwnerAddress, ',' , '.'), 1)


Select *
From MyPortfolioProject..NashvilleHousing

Where OwnerAddress is not Null

-----------------------------------------------------

---Change Y and N to Yes and No in "Sold as Vacant"

Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From MyPortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by SoldAsVacant


Select Distinct(SoldAsVacant),COUNT(SoldAsVacant)
From MyPortfolioProject..NashvilleHousing
Group by SoldAsVacant
Order by 2



Select SoldAsVacant,
Case When SoldASVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END

From MyPortfolioProject..NashvilleHousing


update NashvilleHousing
SET SoldAsVacant =
Case When SoldASVacant = 'Y' THEN 'Yes'
     When SoldAsVacant = 'N' THEN 'No'
	 Else SoldAsVacant
	 END
---------------------------------------------------

--Remove Duplicates

--Step 1


Select*,

ROW_NUMBER() OVER(

PARTITION BY ParcelID,
             PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY 
			    UniqueID
				)row_num





From MyPortfolioProject..NashvilleHousing
order by ParcelID


--Step 2

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From MyPortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE

Where row_num > 1
Order by PropertyAddress



--step 3

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From MyPortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Delete
From RowNumCTE

Where row_num > 1
--Order by PropertyAddress



Select*

From MyPortfolioProject..NashvilleHousing

----Delete Unused Columns



Alter Table MyPortfolioProject..NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress

Alter Table MyPortfolioProject..NashvilleHousing
Drop Column SaleDate



Select*

From MyPortfolioProject..NashvilleHousing

