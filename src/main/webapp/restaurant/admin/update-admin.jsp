<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:include page="/restaurant/partials/menu.jsp"/>

<div class="main-content">
    <div class="wrapper">
        <h1>Update Admin</h1>
        <br><br>

        <form action="" method="POST">

            <table class="tbl-30">
                <tr>
                    <td>Full Name: </td>
                    <td>
                        <input type="text" name="full_name" value="${adminUpdate.fullName }">
                    </td>
                </tr>

                <tr>
                    <td>Username: </td>
                    <td>
                        <input type="text" name="username" value="${adminUpdate.username }">
                    </td>
                </tr>

                <tr>
                    <td colspan="2">
                    	<input type="hidden" name="id" value="${adminUpdate.id }">
                        <input type="submit" name="submit" value="Update Admin" class="btn-secondary">
                    </td>
                </tr>
            </table>

        </form>
    </div>
</div>

<jsp:include page="/restaurant/partials/footer.jsp" />